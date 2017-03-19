//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015-17 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

//the struct to store a user
public struct User
{
    //The name used in app
    public let screenName: String
    //The name used in Twitter
    public let tweetName: String
    //public let profileImageURL: URL?
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?) {
        guard
            let screenName = data?.string(forKeyPath: DiaryKey.screenName),
            let tweetName = data?.string(forKeyPath: DiaryKey.tweetName)
            //let id = data?.string(forKeyPath: DiaryKey.identifier)
            else {
                return nil
        }
        
        self.screenName = screenName
        self.tweetName = tweetName
        //print("\(screenName) \(tweetName)")
        //self.profileImageURL = data?.url(forKeyPath: DiaryKey.profileImageURL)
        
    }
    
    //store all keys in a struct to make the code more concise
    struct DiaryKey {
        static let screenName = "screen_name"
        static let tweetName = "tweet_name"
        //static let identifier = "id_str"
        //static let profileImageURL = "profile_image_url"
    }
}
