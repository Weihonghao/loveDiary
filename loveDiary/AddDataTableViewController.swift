//
//  AddDataTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData

class AddDataTableViewController: UITableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var dateLabel: UITextField!
    @IBOutlet weak var moodControl: UISegmentedControl!
    @IBOutlet weak var textLabel: UITextField!
    
    private func updateDiary() {
        let userName = nameLabel.text  as NSString?
        let location = locationLabel.text as NSString?
        let date = dateLabel.text as NSString?
        let identifier = (Date().ticks as NSNumber).stringValue as NSString
        let text = textLabel.text as NSString?
        let moodList = ["Happy", "Sad", "Angry"]
        let mood = moodList[moodControl.selectedSegmentIndex]
        
        let userDict : NSDictionary = NSDictionary(objects: [userName] as [NSString?], forKeys: ["screen_name"] as [NSString])
        
        let Keys : [NSString] = ["user", "text", "date", "location", "identifier", "mood"]
        let Values : [Any] = [userDict,text!, date!, location!, identifier, mood]
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
        updateDiary()
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let searchViewController = destinationViewController as? DiaryTableViewController {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "showAll" {
                searchViewController.searchText = "all"
            }
        }
    }

}


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
