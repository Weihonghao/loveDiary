//
//  DiaryData.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData
//The dairy entities in CoreData
class DiaryData: NSManagedObject {
    //find whethe it is in CoreData, otherwise create it.
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
        newDiary.user = try? UserData.findOrCreateUser(matching:diaryInfo.user, in: context, recent: diaryInfo.user.screenName)
        print("user \(newDiary.user)")
        //newDiary.query = try? .findOrCreateRecent(matching: queryLower, in: context)
    }
    
}
