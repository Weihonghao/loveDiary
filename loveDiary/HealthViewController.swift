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
    
    
    @IBOutlet weak var timeControlButton: UIButton!
    //display heartRate load from ihealth
    @IBOutlet weak var heartRatelabel: UILabel!
    //display the timer
    @IBOutlet weak var timerLabel: UILabel!
    //display the distance in the time interval
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var timeOrigin = NSDate()
    var timer : Timer = Timer()
    
    //health manager
    let myHealthManager:MyHealthManager = MyHealthManager()
    var heartRate: HKQuantitySample?
    
    var whetherStart = false
    
    let locationManager = CLLocationManager()
    var beginLocation: CLLocation!
    var endLocation: CLLocation!
    var distanceSum = 0.0
    
    //start timer and location updates
    func startTiming() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(HealthViewController.showTime), userInfo: nil, repeats: true)
        timeOrigin = NSDate()
        
        distanceSum = 0.0
        beginLocation = nil
        endLocation = nil
        locationManager.startUpdatingLocation()
        whetherStart = true
        //self.timeControlButton.currentTitle = "Stop Timing"
    }
    
    //stop timer and location updates
    func stopTiming() {
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        whetherStart = false
        //self.timeControlButton.currentTitle = "Start Timing"
    }
    
    //save distance
    func saveDistance() {
        myHealthManager.saveDistance(distanceRecorded: distanceSum, date: NSDate())
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
        let timePassed = NSInteger(NSDate().timeIntervalSince(timeOrigin as Date))
        let realTime = String(Int(timePassed)) + "s"
        self.timerLabel.text = realTime
    }
    
    //read the distance in unit of meter
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if beginLocation == nil {
            beginLocation = locations.first as CLLocation!
        } else {
            let lastDistance = endLocation.distance(from: locations.last as CLLocation!)
            distanceSum += lastDistance
            let realDistance = String(format: "%.2f", distanceSum) + "M"
            
            self.distanceLabel.text = realDistance
        }
        
        endLocation = locations.last as CLLocation!
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.videoView.center.x = self.view.center.x
        optionPicker.dataSource = self
        optionPicker.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        } else {
            print("Please authorize location service first")
        }
        
        if myHealthManager.authorizeHealthKit() {
            self.setHeartRate()
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
        //self.timeControlButton. = "Start Timing"
    }
    
    func setHeartRate() {
        // Create the HKSample for HeartRate.
        let heartRateSample = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)
        print("before get")
        self.myHealthManager.getHeartRate(sampleType: heartRateSample!, completion: { (selfHeartRate, error) -> Void in
            
            if error == nil {
                
                self.heartRate = selfHeartRate as? HKQuantitySample
                print("before transform")
                let heartRateInt = Int(((self.heartRate?.quantity.doubleValue(for: HKUnit.init(from: "count/s")))!*60))
                DispatchQueue.main.async {
                    let realHeartRate = "Your heart rate: " + String(heartRateInt) + " counts/s"
                    self.heartRatelabel.text = realHeartRate
                }
            }
        })
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //used for picker controller
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
    //different function for different options in switch
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
    
    //for audio play
    var sound: AVAudioPlayer?
    func playAudio() {
        let path = Bundle.main.url(forResource: "Rock.mp3", withExtension:nil)!
        
        do {
            sound = try AVAudioPlayer(contentsOf: path)
            sound?.play()
        } catch {
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
        
        //The comment out part is for MPMoviePlayer. However, it is depreciated in ios 10 so we just comment it out. However, they are workable
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
        //we use avplayer for ios 10.0
        player = AVPlayer(playerItem: self.playerItem)
        
        playerLayer = AVPlayerLayer(player: self.player)
        
        
        videoView.frame = CGRect(x: -8, y: 0 , width: self.view.bounds.width, height: self.view.bounds.height*0.4)
        
        //videoView.center.x = self.view.center.x - 50
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
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    // we use socket and  NSURLSession, sockets: Networking API here
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
        // the 'we are the champion mp4 uploaded on my personal website'
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
    
    
    //we use core motion here
    func outputAccData(acceleration: CMAcceleration){
        let accelerationArray = [fabs(acceleration.x),fabs(acceleration.y),fabs(acceleration.z)]
        //we display the max acceleration in the x,y,z direction
        self.accelerationLabel.text = String(format: "%.2f", accelerationArray.max()!)
    }
    
    func outputRotData(rotation: CMRotationRate){
        let rotationArray = [fabs(rotation.x),fabs(rotation.y),fabs(rotation.z)]
        //we display the max rotation in the x,y,z direction
        self.rotationLabel.text = String(format: "%.2f", rotationArray.max()!)
    }
    
}

