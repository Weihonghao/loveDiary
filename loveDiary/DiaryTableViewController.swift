//
//  DiaryTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //tmpDiarys.insert(tmpDiary!, at: 0)
        //diarys.insert(tmpDiarys, at: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    
    
    @IBOutlet weak var searchTextField: UITextField!{
        didSet {
            searchTextField.delegate = self
        }
    }
    
    
    // when the return (i.e. Search) button is pressed in the keyboard
    // we go off to search for the text in the searchTextField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTextField {
            searchText = searchTextField.text
        }
        return true
    }
    
    var searchText: String? {
        didSet {
            searchTextField?.text = searchText
            searchTextField?.resignFirstResponder()
            //lastTwitterRequest = nil                // REFRESHING
            diarys.removeAll()
            searchForTweets()
            tableView.reloadData()
            /*if searchText != nil{
                whichToRemove = recentQuery.addNewQuery(newQuery: searchText!.lowercased())
                //recentQuery.addNewQuery(newQuery: searchText!)
            }*/
            title = searchText
        }
    }
    
    private func searchForTweets() {
        
        print("here")
        let userKeys : [NSString] = ["screen_name"]
        let userVals : [NSString] = ["whh"]
        let userDict : NSDictionary = NSDictionary(objects: userVals, forKeys: userKeys)
        
        
        //let tmpUser = User(data:userDict)
        print("\(userDict)")
        //print("\(tmpUser)")
        let Keys : [NSString] = ["user", "text", "date", "location", "identifier"]
        let Values : [Any] = [userDict, "adsf", "3.12", "Stanford", "d1"]
        let dict : NSDictionary = NSDictionary(objects: Values, forKeys:Keys)
        var tmpDiarys = Array<Diary>()
        let tmpDiary = Diary(data: dict)
        tmpDiarys.insert(tmpDiary!, at: 0)
        print("\(tmpDiarys)")
        
        
        insertDiarys(tmpDiarys)
    }
    
    private var diarys = [Array<Diary>]()
    
    func insertDiarys(_ newDiarys: [Diary]) {
        print("start insert")
        self.diarys.insert(newDiarys, at:0)
        self.tableView.insertSections([0], with: .fade)
        print("diarys \(diarys)")
        print("finish insert")
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return diarys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return diarys[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Diary", for: indexPath)
        
        let diary: Diary = diarys[indexPath.section][indexPath.row]
        
        if let diaryCell = cell as? DiaryTableViewCell {
            diaryCell.diary = diary
        }
        
        return cell
    }
}
