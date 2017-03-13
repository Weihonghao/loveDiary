//
//  DiaryTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let userKeys : [NSString] = ["name", "screen_name", "id_str"]
        let userVals : [NSString] = ["me", "whh", "1"]
        let userDict : NSDictionary = NSDictionary(objects: userVals, forKeys: userKeys)
        
        
        //let tmpUser = User(data:userDict)
        print("\(userDict)")
        //print("\(tmpUser)")
        let Keys : [NSString] = ["user", "text", "date", "location", "identifier"]
        let Values : [Any] = [userDict, "adsf", "3.12", "Stanford", "d1"]
        let dict : NSDictionary = NSDictionary(objects: Values, forKeys:Keys)
        var tmpDiarys = Array<Diary>()
        let tmpDiary = Diary(data: dict)
        
        print("\(tmpDiary)")
        tmpDiarys.insert(tmpDiary!, at: 0)
        diarys.insert(tmpDiarys, at: 0)
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

    
    private var diarys = [Array<Diary>]()
    func insertTweets(_ newDiarys: [Diary]) {
        self.diarys.insert(newDiarys, at:0)
        self.tableView.insertSections([0], with: .fade)
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
