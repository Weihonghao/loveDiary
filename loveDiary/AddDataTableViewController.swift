//
//  AddDataTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MapKit


class AddDataTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    var returnUserDict: NSDictionary? = nil
    let myLocationManager = CLLocationManager()
    
    @IBAction func getCurrentLocation(_ sender: UIButton) {
        mapView.showsUserLocation = true
        locationLabel.text = NSNumber(value: (myLocationManager.location?.coordinate.latitude)! as Double).stringValue + " " + NSNumber(value: (myLocationManager.location?.coordinate.longitude)! as Double).stringValue
        //locationLabel.text = "fuck"
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        
        let coordinations = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpanMake(0.002,0.002)
        let region = MKCoordinateRegion(center: coordinations, span: span)
        
        mapView.setRegion(region, animated: true)
        
    }
    
    
    
    
    @IBAction func checkUser(_ sender: UIButton) {
        if let username = nameLabel.text {
            container?.performBackgroundTask { [weak self] context in
                let match = try? UserData.findUser(in: context, recent: username)
                if match != nil {
                    self?.returnUserDict = NSDictionary(objects: [username as NSString?, match??.tweetName as NSString?] as [NSString?], forKeys: ["screen_name", "tweet_name"] as [NSString])
                    print("return Dict \(self?.returnUserDict)")
                }
                try? context.save()
                self?.printDatabaseStatistics()
            }
        }
    }
    
    
    
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    
    
    @IBOutlet weak var dateLabel: UIDatePicker!
    
    
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var textLabel: UITextField!
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    private func updateDiary() {
        let userName = nameLabel.text  as NSString?
        let location = locationLabel.text as NSString?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date =
            formatter.string(from: dateLabel.date)
        

        let identifier = (Date().ticks as NSNumber).stringValue as NSString
        let text = textLabel.text as NSString?
        let moodList = ["Happy", "Sad", "Angry"]
        let mood = moodList[moodControl.selectedSegmentIndex]
        
        
        let Keys : [NSString] = ["user", "text", "date", "location", "identifier", "mood"]
        let Values : [Any] = [returnUserDict!,text!, date, location!, identifier, mood]
        print ("important now \(returnUserDict)")
        let dict : NSDictionary = NSDictionary(objects: Values, forKeys:Keys)
        updateDatabase(with: [Diary(data: dict)!], for: userName!)
        
    }
    
    
    private func updateDatabase(with diarys: [Diary], for query: NSString) {
        
        //This is for removing tweets when we already have 100 queries in history and try to add a new one. In this way, if the new one is not in the query history, we need to delete the first one and the relevant tweets and mentions.
        // Paul said in lecture we need to print something out for database, that's why I wrap it up in a new function and print the necessary information out.
        //removeNonAccessible(with: searchText!)
        
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            for diaryInfo in diarys {
                let _ = try? DiaryData.findOrCreateDiary(matching: diaryInfo, in: context, recent: query as String)
            }
            try? context.save()
            print("done loading database")
            self?.printDatabaseStatistics()
        }
        
        
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                if Thread.isMainThread {
                    print("on main thread")
                } else {
                    print("off main thread")
                }
                
                if let diaryCount = try? context.count(for: DiaryData.fetchRequest()) {
                    print("\(diaryCount) diaries")
                }
                
                if let userCount = try? context.count(for: UserData.fetchRequest()) {
                    print("\(userCount) users")
                }
            }
        }
    }
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.myLocationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.myLocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            myLocationManager.delegate = self
            myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            myLocationManager.startUpdatingLocation()
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let searchViewController = destinationViewController as? DiaryTableViewController {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "showAll" {
                print("start update diary")
                updateDiary()
                searchViewController.searchText = nil //"all"
            }
        }
    }
    
    
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        //print("try here")
        if let rootController = navigationController?.viewControllers.first as? AddDataTableViewController {
            if rootController == self {
                //print("true")
                return true
            }
        }
        //print("false")
        return false
    }
    
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
