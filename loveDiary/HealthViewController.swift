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

class HealthViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
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
        
        // Do any additional setup after loading the view.
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
    
    
    var optionArray:[String] = ["start timing", "stop timing", "save distance", "play music", "stop music"]
    
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
