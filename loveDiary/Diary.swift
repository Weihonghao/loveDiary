//
//  Diary.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation


public struct Diary
{
    public let text: String
    public let user: User
    public let date: String //Date
    public let location: String
    public let identifier: String
    
    
    init?(data: NSDictionary?)
    {
        guard
            let user = User(data: data?.dictionary(forKeyPath: DiaryKey.user)),
            let text = data?.string(forKeyPath: DiaryKey.text),
            //let created = twitterDateFormatter.date(from: data?.string(forKeyPath: DiaryKey.created) ?? ""),
            let date = data?.string(forKeyPath: DiaryKey.date),
            let location = data?.string(forKeyPath: DiaryKey.location),
            let identifier = data?.string(forKeyPath: DiaryKey.identifier)
            else {
                return nil
        }
        
        self.user = user
        self.text = text
        //self.created = created
        self.date = date
        self.location = location
        self.identifier = identifier
        
        /*self.media = Tweet.mediaItems(from: data?.array(forKeyPath: TwitterKey.media))
        self.hashtags = Tweet.mentions(from: data?.array(forKeyPath: TwitterKey.Entities.hashtags), in: text, with: "#")
        self.urls = Tweet.mentions(from: data?.array(forKeyPath: TwitterKey.Entities.urls), in: text, with: "http")
        self.userMentions = Tweet.mentions(from: data?.array(forKeyPath: TwitterKey.Entities.userMentions), in: text, with: "@")*/
    }
    
    struct DiaryKey {
        static let user = "user"
        static let text = "text"
        static let date = "date"
        static let location = "location"
        static let identifier = "identifier"
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
