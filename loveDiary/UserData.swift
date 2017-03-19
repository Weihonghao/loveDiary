//
//  UserData.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import CoreData
//user entities to store in Core Data
class UserData: NSManagedObject {
    //find whethe it is in CoreData, otherwise create it.
    static func findOrCreateUser(matching userInfo: User, in context: NSManagedObjectContext, recent query: String) throws -> UserData
    {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        if query != "all" {
            request.predicate = NSPredicate(format: "screenName = %@", query)
        }
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                /*for match in matches{
                    print("screenName \(match.screenName)")
                }*/
                assert(matches.count == 1, "Query.findOrCreateTwitterUser -- database inconsistency!")
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let returnUser = UserData(context: context)
        returnUser.screenName = query
        returnUser.tweetName = userInfo.tweetName
        //print("new user query with \(query)")
        return returnUser
    }
    
    
    //find whethe it is in CoreData, return the result
    static func findUser(in context: NSManagedObjectContext, recent query: String) throws -> UserData?
    {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        request.predicate = NSPredicate(format: "screenName = %@", query)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Query.findOrCreateTwitterUser -- database inconsistency!")
                return matches[0]
            }
        } catch {
            throw error
        }
        return nil
    }
    
    //delet the items from the Core Data
    static func deleteUser(in context: NSManagedObjectContext, recent query: String) throws
    {
        let request: NSFetchRequest<UserData> = UserData.fetchRequest()
        request.predicate = NSPredicate(format: "screenName = %@", query)
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                assert(matches.count == 1, "Query.findOrCreateTwitterUser -- database inconsistency!")
                context.delete(matches.first!)
            }
        } catch {
            throw error
        }
    }
    
    
    
}
