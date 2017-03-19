//
//  DiaryTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData

class DiaryTableViewController: FetchedResultsTableViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTextField.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    // when the return (i.e. Search) button is pressed in the keyboard
    // we go off to search for the text in the searchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    var searchText: String? {
        didSet {
            //print("start updating UI")
            updateUI()
            title = searchText
        }
    }
    
    
    var fetchedResultsController: NSFetchedResultsController<DiaryData>?
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{ didSet { updateUI() } }
    
    
    // uodate UI search for your family members' events. The key word is family member's userName
    private func updateUI() {
        //print("popularity query is \(queryText)")
        if let context = container?.viewContext, searchText != nil {
            let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
            // For extra credit 1, in order to get two different sections, we need to add this new sortDescriptors as label
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "user.screenName",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )/*,
                 NSSortDescriptor(
                 key: "count",
                 ascending: false
                 ),
                 NSSortDescriptor(
                 key: "mentionItem",
                 ascending: true,
                 selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                 )*/]
            
            //popular things happen more than 1
            if searchText != "all" {
                request.predicate = NSPredicate(format:"user.screenName = %@", searchText!)
            }
            
            //we set sectionNameKeyPath as label instead of nil
            fetchedResultsController = NSFetchedResultsController<DiaryData>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "user.screenName",
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            print("finish reload data here")
        }
    }
    
    
    
    
    
    /*override func numberOfSections(in tableView: UITableView) -> Int {
     return diarys.count
     }
     
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return diarys[section].count
     }*/
    
    /*override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath)
     
     let diary: Diary = diarys[indexPath.section][indexPath.row]
     print("new Diary \(diary)")
     if let diaryCell = cell as? DiaryTableViewCell {
     diaryCell.diary = diary
     }
     
     return cell
     }*/
    //return the cell to display
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("\(fetchedResultsController?.sections?.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath) as! DiaryTableViewCell // edit here
        
        if let newDiary = fetchedResultsController?.object(at: indexPath) {
            //print("mentinoitem is \(mention.mentionItem)")
            cell.diaryDateLabel.text = newDiary.date
            cell.diaryLocationLabel.text = newDiary.location
            cell.userLabel.text = newDiary.user?.screenName
            cell.diaryTextLabel.text = newDiary.text
            //let tweetCount = tweetCountWithMentionBy(twitterUser)
            //cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        
        return cell
    }
}
