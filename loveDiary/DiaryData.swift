//
//  DiaryData.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData

class DiaryData: NSManagedObject {
    class func findOrCreateDiary(matching diaryInfo: Diary, in context: NSManagedObjectContext, recent query: String) throws
    {
        //lowercase all the query and keywords since we need to be case-insensitive
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        //if query != "all" {
            request.predicate = NSPredicate(format: "id = %@ and user.screenName = %@", diaryInfo.identifier, query)
        //}
        do {
            _ = try context.fetch(request)
        } catch {
            throw error
        }
        //If not find, we need to create a new one
        let newDiary = DiaryData(context: context)
        newDiary.id = diaryInfo.identifier
        newDiary.text = diaryInfo.text
        newDiary.location = diaryInfo.location
        newDiary.date = diaryInfo.date
        newDiary.mood = diaryInfo.mood
        newDiary.user = try? UserData.findOrCreateUser(matching: diaryInfo.user.screenName, in: context)
        print("user \(newDiary.user)")
        //newDiary.query = try? .findOrCreateRecent(matching: queryLower, in: context)
    }
    
    /*class func readDiary(in context: NSManagedObjectContext, recent query: String) throws -> [Diary]
    {
        let request: NSFetchRequest<DiaryData> = DiaryData.fetchRequest()
        if query != "all" {
            request.predicate = NSPredicate(format:"user.screenName = %@",query)
        }
        do {
            let matches = try context.fetch(request)
            var matchList = [Diary]()
            for match in matches {
                //let userName = (try? UserData.findOrCreateUser(matching: query, in: context))?.screenName
                let userName = match.user?.screenName
                let userDict : NSDictionary = NSDictionary(objects: [userName ?? "No user"], forKeys: ["screen_name"] as [NSString])
                
                let text = match.text
                let date = match.date
                let location = match.location
                let identifier = match.id
                let mood = match.mood
                let Keys : [NSString] = ["user", "text", "date", "location", "identifier", "mood"]
                let Values : [Any] = [userDict,text!, date!, location!, identifier!, mood!]
                let dict : NSDictionary = NSDictionary(objects: Values, forKeys:Keys)
                matchList.insert(Diary(data: dict)!, at: 0)
            }
            return matchList
        } catch {
            throw error
        }
    }*/

}
