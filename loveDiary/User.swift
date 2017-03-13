//
//  User.swift
//  Twitter
//
//  Created by CS193p Instructor.
//  Copyright (c) 2015-17 Stanford University. All rights reserved.
//

import Foundation

// container to hold data about a Twitter user

public struct User
{
    public let screenName: String
    public let name: String
    public let id: String
    //public let profileImageURL: URL?
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?) {
        guard
            let screenName = data?.string(forKeyPath: DiaryKey.screenName),
            let name = data?.string(forKeyPath: DiaryKey.name),
            let id = data?.string(forKeyPath: DiaryKey.identifier)
        else {
                return nil
        }
        
        self.screenName = screenName
        self.name = name
        self.id = id
        print("\(screenName) \(name) \(id)")
        //self.profileImageURL = data?.url(forKeyPath: DiaryKey.profileImageURL)
        
    }
    
    
    struct DiaryKey {
        static let name = "name"
        static let screenName = "screen_name"
        static let identifier = "id_str"
        //static let profileImageURL = "profile_image_url"
    }
}
