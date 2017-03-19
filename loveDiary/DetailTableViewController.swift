//
//  DetailTableViewController.swift
//  Smashtag
//
//  Created by WeiHonghao on 17/2/14.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit
import Twitter


class DetailTableViewController: UITableViewController {
    
    
    @IBAction func unwindToRoot(sender: UIStoryboardSegue) { }
    //There should be title for the section and also an array of contents
    private struct mentionItem {
        var title: String
        var content: [mentionType]
    }
    
    // keyword involves hashtag, url and userMentioned
    private enum mentionType {
        case keyword(String)
        case image(URL, Double)
    }
    
    private var mentionList : [mentionItem] = []
    
    //add new mentionItem into the mentionList when there are any new tweet
    public var tweet: Twitter.Tweet? {
        didSet{
            title = tweet?.user.screenName
            if let media = tweet?.media {
                mentionList.append(mentionItem(title: "Images", content: media.map { mentionType.image($0.url, $0.aspectRatio) }))
            }
            
            if let url = tweet?.urls {
                mentionList.append(mentionItem(title: "Urls", content: url.map { mentionType.keyword($0.keyword) }))
            }
            
            if let hashtag = tweet?.hashtags {
                mentionList.append(mentionItem(title: "Hashtags", content: hashtag.map { mentionType.keyword($0.keyword) }))
            }
            
            if let userMention = tweet?.userMentions {
                var userList = [mentionType.keyword("@"+(tweet?.user.screenName)!)]
                userList += userMention.map{ mentionType.keyword($0.keyword) }
                mentionList.append(mentionItem(title: "User Mentions", content: userList))
                //mentionList.append(mentionItem(title: "User Mentions", content: userMention.map { mentionType.keyword($0.keyword) }))
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        //tableView.estimatedRowHeight = tableView.rowHeight
        // but use whatever autolayout says the height should be as the actual row height
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /*override func didReceiveMemoryWarning() {
     super.didReceiveMemoryWarning()
     // Dispose of any resources that can be recreated.
     }*/
    
    // MARK: - Table view data source
    
    // the number of section is the length of mentionList
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentionList.count
    }
    
    
    // the number of row of different section is the length of the array as the content in each member of mentionList
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentionList[section].content.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachMention = mentionList[indexPath.section].content[indexPath.row]
        
        switch eachMention {
        case .image(let url, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageMedia", for: indexPath) as? DetailTableViewCell
            cell?.imageUrl = url
            return cell!
        // keyword includes hashtag, url and userMentioned
        case .keyword(let keywordString):
            let cell = tableView.dequeueReusableCell(withIdentifier: "keywordMention", for: indexPath)
            cell.textLabel?.text = keywordString
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let eachMention = mentionList[indexPath.section].content[indexPath.row]
        switch eachMention{
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
        
    }
    
    //There is header only when the content array is not null
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if mentionList[section].content.count > 0 {
            return mentionList[section].title
        }
        return nil
    }
    
    
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //go back to the search page when trigger hashtag and userMentioned
        if let searchViewController = destinationViewController as? TweetTableViewController, let currentCell = sender as? UITableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "goBackToSearch" {
                searchViewController.searchText = (currentCell.textLabel?.text ?? "")
            }
        }
        //segue to show the larger picture in scroll view
        if let imageViewController = destinationViewController as? pictureViewController , let currentCell = sender as? DetailTableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "showPicture" {
                imageViewController.imageUrl = (currentCell.imageUrl)
            }
        }
        // for extra credit, segue to show url content inside the application
        if let webViewController = destinationViewController as? WebViewController , let currentCell = sender as? UITableViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "showWeb" {
                webViewController.webUrl = URL(string:(currentCell.textLabel?.text ?? ""))
            }
        }
    }
    
    // try to see whether we need to segue to another controller
    override func shouldPerformSegue(withIdentifier identifier: String?, sender: Any?) -> Bool {
        if identifier == "goBackToSearch", let currentCell = sender as? UITableViewCell {
            if let target = currentCell.textLabel?.text {
                //start a safari browser, comment it because for extra credit, we need to read url content inside the app.
                /*if target.hasPrefix("http") {
                 if #available(iOS 10, *) {
                 UIApplication.shared.open(URL(string:target)!, options: [:])
                 }
                 else {
                 UIApplication.shared.openURL(URL(string:target)!)
                 }
                 return false
                 }*/
                
                if target.hasPrefix("http") {
                    performSegue(withIdentifier: "showWeb", sender: sender)
                    return false
                }
            }
            //segue back when it is a hashtag or userMentioned
            return true
        }
        //if it is the image
        if identifier == "showPicture", let currentCell = sender as? DetailTableViewCell {
            if currentCell.imageUrl != nil {
                return true
            }
        }
        // need this one, otherwise you cannot go back to the root
        if identifier == "backFromMention" {
            return true
        }
        return false
    }
}
