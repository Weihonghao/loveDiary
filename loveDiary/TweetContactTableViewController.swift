//
//  TweetContactTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/14.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData

class TweetContactTableViewController: FetchedResultsTableViewController, UISearchBarDelegate, UITextFieldDelegate {
    
    
    
    /*@IBOutlet weak var searchTextField: UITextField!{
     didSet {
     searchTextField.delegate = self
     }
     }
     
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     if textField == searchTextField {
     queryText = searchTextField.text
     }
     return true
     }*/
    
    
    var queryText: String? {
        didSet {
            print("start updating UI")
            updateUI()
        }
    }
    //use of searchbar
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet {
            searchBar.delegate = self
            
            searchBar.autocapitalizationType = .none
        }
    }
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = true
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true;
        return true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsScopeBar = false
        searchBar.sizeToFit()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false;
        searchBar.resignFirstResponder()
        searchBar.endEditing(true)
        return true
    }
    
    //when clicking on search, hide the keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        queryText = searchBar.text
        //print("query is \(queryText)")
        searchBar.endEditing(true)
    }
    
    //when clicking on cancel, hide the keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    var fetchedResultsController: NSFetchedResultsController<UserData>?
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        { didSet { updateUI() } }
    
    
    //search by users' screenName
    private func updateUI() {
        print("start updating ui")
        //print("\(self.searchBar.selectedScopeButtonIndex)")
        if let context = container?.viewContext, queryText != nil {
            let request: NSFetchRequest<UserData> = UserData.fetchRequest()
            // For extra credit 1, in order to get two different sections, we need to add this new sortDescriptors as label
            request.sortDescriptors = [
                NSSortDescriptor(
                    key: "screenName",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            
            //popular things happen more than 1
            let selectIndex = self.searchBar.selectedScopeButtonIndex
            if selectIndex == 0 {
                request.predicate = NSPredicate(format: "screenName = %@", queryText!)
            } else if selectIndex == 1 {
                request.predicate = NSPredicate(format: "tweetName = %@", queryText!)
            }
            
            //request.predicate = nil
            
            
            //we set sectionNameKeyPath as label instead of nil
            fetchedResultsController = NSFetchedResultsController<UserData>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: "screenName",
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
            //print("finish reload data")
        }
    }
    
    
    var screenNameArray:[String] = [String]()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //print("\(fetchedResultsController?.sections?.count)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetContactCell", for: indexPath) // edit here
        
        if let contact = fetchedResultsController?.object(at: indexPath) {
            //print("mentinoitem is \(mention.mentionItem)")
            print("screenName \(contact.screenName)")
            cell.textLabel?.text = contact.screenName
            cell.detailTextLabel?.text = contact.tweetName
            screenNameArray.append(contact.screenName!)
            //let tweetCount = tweetCountWithMentionBy(twitterUser)
            //cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        print("before return")
        return cell
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
    
    
    //segue to tweet search
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //segue back to search the queries in history
        if let EachUserViewController = destinationViewController as? TweetTableViewController, let currentCell = sender as? UITableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "seeEachTweeter" {
                var tweetName = currentCell.detailTextLabel?.text
                if tweetName?.hasPrefix("@") == false {
                    tweetName = "@" + tweetName!
                }
                EachUserViewController.searchText = tweetName
            }
        }
    }
    
    
    //unwind segue
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        //print("try here")
        if let rootController = navigationController?.viewControllers.first as? TweetTableViewController {
            if rootController == self {
                //print("true")
                return true
            }
        }
        //print("false")
        return false
    }
    
    /*override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     container?.performBackgroundTask { [weak self] context in
     if let _ = try? UserData.deleteUser(in: context, recent: (self?.screenNameArray[indexPath.row])!) {
     
     self?.screenNameArray.remove(at: indexPath.row)
     }
     
     try? context.save()
     self?.tableView.deleteRows(at: [indexPath], with: .fade)
     }
     print("asd \(indexPath)")
     
     
     
     }
     }*/
    
    
    // MARK: - Table view data source
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
