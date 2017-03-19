//
//  HealthViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/17.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit
import AVFoundation
import MediaPlayer
import AVKit
import CoreMotion

class HealthViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate, URLSessionDelegate {
    
    
    
    @IBOutlet weak var heartRatelabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var zeroTime = NSDate()
    var timer : Timer = Timer()
    
    let locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var distanceTraveled = 0.0
    
    let myHealthManager:MyHealthManager = MyHealthManager()
    var heartRate: HKQuantitySample?
    
    var whetherStart = false
    
    
    func startTiming() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(HealthViewController.showTime), userInfo: nil, repeats: true)
        zeroTime = NSDate()
        
        distanceTraveled = 0.0
        startLocation = nil
        lastLocation = nil
        locationManager.startUpdatingLocation()
        whetherStart = true
    }
    
    
    func stopTiming() {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        whetherStart = false
    }
    
    
    func saveDistance() {
        myHealthManager.saveDistance(distanceRecorded: distanceTraveled, date: NSDate())
    }
    
    @IBAction func timeControl(_ sender: UIButton) {
        
        if self.whetherStart == false {
            startTiming()
        } else {
            stopTiming()
        }
    }
    
    @IBAction func saveDistance(_ sender: UIButton) {
        saveDistance()
    }
    
    
    @IBOutlet weak var optionPicker: UIPickerView!
    
    
    
    func showTime() {
        let timePassed = NSInteger(NSDate().timeIntervalSince(zeroTime as Date))
        let realTime = String(Int(timePassed)) + "s"
        self.timerLabel.text = realTime
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if startLocation == nil {
            startLocation = locations.first as CLLocation!
        } else {
            let lastDistance = lastLocation.distance(from: locations.last as CLLocation!)
            distanceTraveled += lastDistance
            let realDistance = String(format: "%.2f", distanceTraveled) + "M"
            
            self.distanceLabel.text = realDistance
        }
        
        lastLocation = locations.last as CLLocation!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoView.center.x = self.view.center.x
        optionPicker.dataSource = self
        optionPicker.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        print("fuck here")
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Please authorize location service first")
        }
        
        if myHealthManager.authorizeHealthKit() {
            print("succeed to fuck")
            self.setHeartRate()
        } else {
            print("fail to fuck")
        }
        //startDownload()
        //print("finish downloading")
        
        // Do any additional setup after loading the view.
        movementManager.gyroUpdateInterval = 0.2
        movementManager.accelerometerUpdateInterval = 0.2
        
        movementManager.startAccelerometerUpdates(to: OperationQueue.current!) { (accelerometerData: CMAccelerometerData?, NSError) -> Void in
            self.outputAccData(acceleration: accelerometerData!.acceleration)
            if(NSError != nil) {
                print("\(NSError)")
            }
        }
        
        movementManager.startGyroUpdates(to: OperationQueue.current!, withHandler: { (gyroData: CMGyroData?, NSError) -> Void in
            self.outputRotData(rotation: gyroData!.rotationRate)
            if (NSError != nil){
                print("\(NSError)")
            }
        })
    }
    
    func setHeartRate() {
        // Create the HKSample for HeartRate.
        let heartRateSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        
        // Call HealthKitManager's getSample() method to get the user's heartRate.
        print("before get")
        self.myHealthManager.getHeartRate(sampleType: heartRateSample!, completion: { (selfHeartRate, error) -> Void in
            
            if error == nil {
                
                self.heartRate = selfHeartRate as? HKQuantitySample
                print("before transform")
                let heartRateInt = Int(((self.heartRate?.quantity.doubleValue(for: HKUnit.init(from: "count/s")))!*60))
                DispatchQueue.main.async {
                    let realHeartRate = String(heartRateInt) + " counts/s"
                    self.heartRatelabel.text = realHeartRate
                }
            }
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var optionArray:[String] = ["start timing", "stop timing", "save distance", "play music", "stop music", "play video", "stop video"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.optionArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch row {
        case 0:
            startTiming()
        case 1:
            stopTiming()
        case 2:
            saveDistance()
        case 3:
            playAudio()
        case 4:
            stopAudio()
        case 5:
            playVideo()
        case 6:
            stopVideo()
        default:
            print("impossible")
        }
    }
    
    
    var sound: AVAudioPlayer?
    //var bombSoundEffect: AVAudioPlayer!
    func playAudio() {
        let path = Bundle.main.url(forResource: "Rock.mp3", withExtension:nil)!
        //let url = URL(fileURLWithPath: path)
        
        do {
            sound = try AVAudioPlayer(contentsOf: path)
            //bombSoundEffect = sound
            sound?.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func stopAudio() {
        if sound != nil {
            sound?.stop()
            sound = nil
        }
    }
    
    //var moviePlayerController:MPMoviePlayerViewController?
    
    
    var player : AVPlayer? = nil
    var playerLayer : AVPlayerLayer? = nil
    var asset : AVAsset? = nil
    var playerItem: AVPlayerItem? = nil
    
    
    @IBOutlet weak var videoView: UIView!
    
    func playVideo() {
        /*let path = Bundle.main.url(forResource: "RockVideo.mp4", withExtension: nil)!
         //let path = NSURL(string: "https://www.youtube.com/watch?v=-tJYN-eG1zk")
         
         
         
         let moviePlayerController = MPMoviePlayerController(contentURL: path as URL!)
         
         moviePlayerController?.shouldAutoplay = true
         moviePlayerController?.movieSourceType = MPMovieSourceType.file
         
         
         moviePlayerController?.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height/2.0)
         
         
         moviePlayerController?.view.tag = 100
         self.view.addSubview((moviePlayerController?.view)!)
         
         moviePlayerController?.movieSourceType = MPMovieSourceType.streaming;
         moviePlayerController?.prepareToPlay()
         moviePlayerController?.play()*/
        
        
        var path:URL
        if wetherDownload == false {
            path = Bundle.main.url(forResource: "RockVideo.mp4", withExtension: nil)!
        }
        else {
            let tmpUrl = "myVideo/" + String(myFileSystem.fileNumber("myVideo")-1) + ".mp4"
            let localUrl = myFileSystem.getDir(tmpUrl)
            print("\(localUrl)")
            path = URL(fileURLWithPath:localUrl)
            print("ahahhahah \(path)")
        }
        asset = AVAsset(url:path)
        playerItem = AVPlayerItem(asset: asset!)
        
        player = AVPlayer(playerItem: self.playerItem)
        
        playerLayer = AVPlayerLayer(player: self.player)
        
        
        videoView.frame = CGRect(x: 0, y: 0 , width: self.view.bounds.width, height: self.view.bounds.height*0.4)
        
        
        playerLayer!.frame = videoView.frame
        playerLayer!.videoGravity = AVLayerVideoGravityResizeAspect
        videoView.layer.insertSublayer(self.playerLayer!, at:0)
        
        
        player!.play()
        
        
    }
    
    
    func stopVideo() {
        if self.player != nil, self.playerLayer != nil {
            self.player!.pause()
            self.playerLayer!.removeFromSuperlayer()
        }
    }
    
    
    
    
    /*let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
     var dataTask: URLSessionDataTask?
     var activeDownloads = [String: DownloadItem]()
     let downloadUrl = "https://r11---sn-n4v7kne7.googlevideo.com/videoplayback?id=o-AFIzryvkq1yM3IHgurYMXpEG6UmSqmsU3da_jHQMc1Ow&requiressl=yes&ip=128.12.246.17&signature=6BB413A4486A4CFDA61E43DF2AE9FAE8C3A942E5.3B4E567AD2513F3B9E1BA080B4DFCB811B8B771A&gir=yes&ipbits=0&itag=18&sparams=clen,dur,ei,expire,gir,id,initcwndbps,ip,ipbits,ipbypass,itag,lmt,mime,mm,mn,ms,mv,pl,ratebypass,requiressl,source,upn&upn=2k6W9x4fsEg&expire=1489879098&clen=23714984&pl=18&mime=video/mp4&dur=626.056&ratebypass=yes&source=youtube&ei=2mvNWJKjD9Hz-gPOxZaIBA&lmt=1460136183582485&key=cms1&title=%E8%9B%A4%E4%B8%89%E7%AF%87%E4%B9%8B%E8%A7%86%E5%AF%9F%E4%BA%8C%E9%99%A2%E8%9B%A4%E4%B8%89%E7%AF%87%E4%B9%8B%E8%A7%86%E5%AF%9F%E4%BA%8C%E9%99%A2_HDWon.Com.mp4&redirect_counter=1&req_id=78e080396bdaa3ee&cms_redirect=yes&ipbypass=yes&mm=31&mn=sn-n4v7kne7&ms=au&mt=1489857389&mv=m"
     
     lazy var downloadsSession: URLSession = {
     let configuration = URLSessionConfiguration.default
     let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
     return session
     }()
     
     func startDownload() {
     if let urlString =  URL(string: downloadUrl) {
     // 1
     let download = DownloadItem(url: downloadUrl)
     // 2
     download.downloadTask = downloadsSession.downloadTask(with: urlString)
     // 3
     download.downloadTask!.resume()
     // 4
     download.isDownloading = true
     // 5
     activeDownloads[download.url] = download
     }
     }*/
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func downloadControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 2:
            startDownload()
        case 1:
            playVideo()
        case 0:
            stopVideo()
        default:
            print("Impossible")
        }
    }
    let myFileSystem = MyFileSystem()
    var myDonwload = DownloadItem()
    var wetherDownload = false
    func startDownload() {
        if myFileSystem.checkDirExist("myVideo") == false {
            myFileSystem.createDir("myVideo")
        }
        //let webUrl = NSURL(string: "http://infolab.stanford.edu/~ullman/mmds/ch5.pdf")
        let webUrl = NSURL(string: "http://weihonghao.github.io/img/videoDownload.mp4")
        let tmpUrl = "myVideo/" + String(myFileSystem.fileNumber("myVideo")) + ".mp4"
        let localUrl = myFileSystem.getDir(tmpUrl)
        print("\(localUrl)")
        myDonwload.load(url: webUrl as! URL, to: URL(fileURLWithPath: localUrl)) {
            print("download succeed")
        }
        self.wetherDownload = true
    }
    
    
    
    @IBOutlet weak var accelerationLabel: UILabel!
    
    @IBOutlet weak var rotationLabel: UILabel!
    var movementManager = CMMotionManager()
    
    
    
    func outputAccData(acceleration: CMAcceleration){
        let accelerationArray = [fabs(acceleration.x),fabs(acceleration.y),fabs(acceleration.z)]
        self.accelerationLabel.text = String(format: "%.2f", accelerationArray.max()!)
    }
    
    func outputRotData(rotation: CMRotationRate){
        let rotationArray = [fabs(rotation.x),fabs(rotation.y),fabs(rotation.z)]
        self.rotationLabel.text = String(format: "%.2f", rotationArray.max()!)
    }
    
}

