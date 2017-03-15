//
//  AddUserTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/13.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddUserTableViewController: UITableViewController, UNUserNotificationCenterDelegate {
    

    
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    
    
    
    @IBOutlet weak var userNameLabel: UITextField!
    
    @IBOutlet weak var tweetNameLabel: UITextField!
    
    @IBAction func submitRegister(_ sender: UIButton) {
        updateUser()
        //center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        //}
        print("notification notification")
        let content = UNMutableNotificationContent()
        content.title = "New User"
        content.body = "You just add a new user"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "reminder"
        // Deliver the notification in five seconds.
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: nil)

        let center = UNUserNotificationCenter.current()
        center.add(request)
        
        /*let notification = UILocalNotification()
        notification.alertBody = "Hello, local notifications!"
        notification.fireDate = NSDate().addingTimeInterval(1) as Date // 10 seconds after now
        UIApplication.shared.scheduleLocalNotification(notification)*/
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    private func updateUser() {
        let userName = userNameLabel.text  as NSString?
        let tweetName = tweetNameLabel.text as NSString?
        
        
        let userDict : NSDictionary = NSDictionary(objects: [userName, tweetName] as [NSString?], forKeys: ["screen_name", "tweet_name"] as [NSString])
        if userNameLabel.text != Optional("") {
            updateDatabase(with: User(data: userDict)!, for: userName!)
        }
        
    }
    
    
    
    private func updateDatabase(with user: User, for query: NSString) {
        container?.performBackgroundTask { [weak self] context in
            let _ = try? UserData.findOrCreateUser(matching: user, in: context, recent: query as String)
            try? context.save()
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
                
                if let userCount = try? context.count(for: UserData.fetchRequest()) {
                    print("\(userCount) users")
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //updateUser()
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let searchViewController = destinationViewController as? AddDataTableViewController, let currentCell = sender as? UITableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "backToNewDiary" {
                print("prepare success")
                //searchViewController.nameLabel.text = currentCell.userNameLabel.text
            }
        }
    }
    
}
