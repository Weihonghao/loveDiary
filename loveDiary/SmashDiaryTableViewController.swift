//
//  SmashDiaryTableViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData


class SmashDiaryTableViewController: DiaryTableViewController {

    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertDiarys(_ newDiarys: [Diary]) {
        super.insertDiarys(newDiarys)
        updateDatabase(with: newDiarys)
    }
    
    private func updateDatabase(with diarys: [Diary]) {
        
        //This is for removing tweets when we already have 100 queries in history and try to add a new one. In this way, if the new one is not in the query history, we need to delete the first one and the relevant tweets and mentions.
        // Paul said in lecture we need to print something out for database, that's why I wrap it up in a new function and print the necessary information out.
        //removeNonAccessible(with: searchText!)
        
        print("starting database load")
        container?.performBackgroundTask { [weak self] context in
            for diaryInfo in diarys {
                if self?.searchText != nil {
                    let _ = try? DiaryData.findOrCreateDiary(matching: diaryInfo, in: context, recent: (self?.searchText!)!)
                }
            }
            try? context.save()
            print("done loading database")
            //self?.printDatabaseStatistics()
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
