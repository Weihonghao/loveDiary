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

class AddDataTableViewController: UITableViewController, CLLocationManagerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    var myFileSystem: MyFileSystem = MyFileSystem()
    
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBAction func deletePicture(_ sender: UIButton) {
        let pNumber =  myFileSystem.fileNumber("myImage") - 1
        let dir = "myImage/" + String(describing: pNumber) + ".png"
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.myFileSystem.deleteFile(dir)
        }
        
        //handleDelete(dir)
        handleAlert(first: "You have deleted image", second: "Delete Image")
    }
    
    
    /*func handleDelete(_ name:String) {
        let m = "You have deleted image " + name
        let alert = UIAlertController(
            title: "Delete Image",
            message: m,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }*/
    
    
    @IBAction func photofromLibrary(_ sender: UIButton) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    
    @IBAction func photoFromLibraryPop(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        picker.modalPresentationStyle = .popover
        present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        }
        else {
            //handleNoCamera()
            handleAlert(first: "No Camera", second: "You donnot have a camera on a simulator")
        }
    }
    
    /*func handleNoCamera() {
        let alert = UIAlertController(
            title: "No Camera",
            message: "You donnot have a camera on a simulator",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }*/
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = chosenImage
        let imageData = UIImagePNGRepresentation(chosenImage)!
        let dir = "myImage/" + String(myFileSystem.fileNumber("myImage")) + ".png"
        let imageURL = URL(fileURLWithPath: myFileSystem.getDir(dir))
        print("\(imageURL)")
        DispatchQueue.global(qos: .userInitiated).async {
            try! imageData.write(to: imageURL)
        }
        dismiss(animated:true, completion: nil)
    }
    
    
    
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
    
    
    func handleNoUserName() {
        let alert = UIAlertController(
            title: "No UserName",
            message: "Type in UserName below and push confirm button to see whether you have registerred",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: {action in
                self.nameLabel?.text = alert.textFields?.first?.text
        }))
        alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showAll" && self.nameLabel.text == Optional("") {
            print("hinder segue")
            handleNoUserName()
            return false
        }
        //print("user name here \(self.nameLabel.text)")
        //print(self.nameLabel.text == nil)
        //print(self.nameLabel.text)
        return super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
    }
    
    
    
    func handleNoSuchUser() {
        let alert = UIAlertController(
            title: "No Such User",
            message: "Please use 'add User' to register, thanks",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: {action in
                self.nameLabel?.text = alert.textFields?.first?.text
                self.performSegue(withIdentifier: "addUser", sender: nil)
        }))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }
    
    
    
    /*func handleHasUser() {
        let alert = UIAlertController(
            title: "User registered",
            message: "Please finish other blanks",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
    }*/
    
    
    
    @IBAction func checkUser(_ sender: UIButton) {
        if let username = nameLabel.text {
            container?.performBackgroundTask { [weak self] context in
                let match = try? UserData.findUser(in: context, recent: username)
                if match != nil {
                    self?.returnUserDict = NSDictionary(objects: [username as NSString?, match??.tweetName as NSString?] as [NSString?], forKeys: ["screen_name", "tweet_name"] as [NSString])
                    //print(match! == nil)
                    print("return Dict \(self?.returnUserDict)")
                }
                try? context.save()
                self?.printDatabaseStatistics()
                if match != nil, match! == nil {
                    print("No such User")
                    DispatchQueue.main.async {
                        self?.handleNoSuchUser()
                    }
                } else if match != nil, match! != nil {
                    DispatchQueue.main.async {
                        //self?.handleHasUser()
                        self?.handleAlert(first: "User registered", second: "Please finish other blanks")
                    }
                }
                
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
        picker.delegate = self
        // Ask for Authorisation from the User.
        self.myLocationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.myLocationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            myLocationManager.delegate = self
            myLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            myLocationManager.startUpdatingLocation()
        }
        
        if myFileSystem.checkDirExist("myImage") == false {
            myFileSystem.createDir("myImage")
        }
        //print(myFileSystem.checkDirExist("myImage"))
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        registerSettingsBundle()
        updateDisplayFromDefaults()
        self.locationLabel.delegate = self
        self.nameLabel.delegate = self
        self.textLabel.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
     print("finish debug here")
     //searchViewController.searchText = nil //"all"
     }
     }
     }*/
    
    
    @IBAction func backToTab(_ sender: UIButton) {
        if self.nameLabel.text != Optional(""), self.locationLabel.text != Optional(""), self.textLabel.text != Optional("") {
        updateDiary()
        presentingViewController?.dismiss(animated: true)
        } else {
            
            handleAlert(first: "Mising Information", second: "Please finish all the blank")
            /*let alert = UIAlertController(
                title: "Mising Information",
                message: "Please finish all the blank",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil))
            //alert.addTextField(configurationHandler:nil)
            present(
                alert,
                animated: true)*/
        }
    }
    
    
    func handleAlert(first titleInput: String, second messageInput: String) {
        let alert = UIAlertController(
            title: titleInput,
            message: messageInput,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil))
        //alert.addTextField(configurationHandler:nil)
        present(
            alert,
            animated: true)
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
    
    
    func registerSettingsBundle(){
        var appDefaults = [String:AnyObject]()
        appDefaults["myMood"] = 2 as AnyObject?
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
    }
    
    func updateDisplayFromDefaults(){
        //Get the defaults
        let defaults = UserDefaults.standard
        //Set the controls to the default values.
        print("fuck here \(defaults.integer(forKey: "myMood"))")
        self.moodControl.selectedSegmentIndex = defaults.integer(forKey: "myMood")
    }
    
}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
