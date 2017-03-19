//
//  Diary.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation

//class for storing a diary item
public struct Diary
{
    public let text: String
    public let user: User
    public let date: String //Date  // we turn the Date entities in to srting when store it to Core Data
    public let location: String
    public let identifier: String
    public let mood: String // the Mood chosen from segmented control
    
    
    init?(data: NSDictionary?)
    {
        guard
            let user = User(data: data?.dictionary(forKeyPath: DiaryKey.user)),
            let text = data?.string(forKeyPath: DiaryKey.text),
            //let created = twitterDateFormatter.date(from: data?.string(forKeyPath: DiaryKey.created) ?? ""),
            let date = data?.string(forKeyPath: DiaryKey.date),
            let location = data?.string(forKeyPath: DiaryKey.location),
            let identifier = data?.string(forKeyPath: DiaryKey.identifier),
            let mood = data?.string(forKeyPath: DiaryKey.mood)
            else {
                return nil
        }
        
        self.user = user
        self.text = text
        //self.created = created
        self.date = date
        self.location = location
        self.identifier = identifier
        self.mood = mood
        
    }
    
    
    //store all keys in a struct to make the code more concise
    struct DiaryKey {
        static let user = "user"
        static let text = "text"
        static let date = "date"
        static let location = "location"
        static let identifier = "identifier"
        static let mood = "mood"
        /*static let media = "entities.media"
         struct Entities {
         static let hashtags = "entities.hashtags"
         static let urls = "entities.urls"
         static let userMentions = "entities.user_mentions"
         static let indices = "indices"
         static let text = "text"
         }*/
    }
}
