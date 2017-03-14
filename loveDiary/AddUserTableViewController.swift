//
//  AddUserTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/13.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData

class AddUserTableViewController: UITableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    @IBOutlet weak var userNameLabel: UITextField!
    
    @IBOutlet weak var tweetNameLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    private func updateUser() {
        let userName = userNameLabel.text  as NSString?
        let tweetName = tweetNameLabel.text as NSString?
        
        
        let userDict : NSDictionary = NSDictionary(objects: [userName, tweetName] as [NSString?], forKeys: ["screen_name", "tweet_name"] as [NSString])
        
        updateDatabase(with: User(data: userDict)!, for: userName!)
        
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
        updateUser()
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let searchViewController = destinationViewController as? AddDataTableViewController, let currentCell = sender as? AddUserTableViewController {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "backToNewDiary" {
                searchViewController.nameLabel.text = currentCell.userNameLabel.text
            }
        }
    }
    
}
