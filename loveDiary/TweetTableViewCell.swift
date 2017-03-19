//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor on 2/8/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    // outlets to the UI components in our Custom UITableViewCell
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetUserLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    // public API of this UITableViewCell subclass
    // each row in the table has its own instance of this class
    // and each instance will have its own tweet to show
    // as set by this var
    var tweet: Twitter.Tweet? { didSet { updateUI() } }
    //different colors for hashtag, url and userMentioned
    private struct newColor {
        let hashtagNewColor = UIColor.blue
        let urlNewColor = UIColor.cyan
        let userMentionNewColor = UIColor.green
    }
    
    private var colorStruct = newColor()
    //private let hashtagNewColor = UIColor.blue
    //private let urlNewColor = UIColor.cyan
    //private let userMentionNewColor = UIColor.green
    
    // whenever our public API tweet is set
    // we just update our outlets using this method
    private func updateUI() {
        //tweetTextLabel?.text = tweet?.text
        let attributeText = NSMutableAttributedString(string: tweet?.text ?? "")
        attributeText.changeColor(keywords: tweet?.hashtags, color: colorStruct.hashtagNewColor)
        attributeText.changeColor(keywords: tweet?.urls, color: colorStruct.urlNewColor)
        attributeText.changeColor(keywords: tweet?.userMentions, color: colorStruct.userMentionNewColor)
        tweetTextLabel?.attributedText = attributeText
        tweetUserLabel?.text = tweet?.user.description
        
        if let profileImageURL = tweet?.user.profileImageURL {
            // FIXME: blocks main thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: profileImageURL)
                if let imageData = urlContents, profileImageURL == self?.tweet?.user.profileImageURL{
                    DispatchQueue.main.async {
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }
        
        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}

// here we add an extention to the NSMutableAttributedString so that we don't need to repeatedly call changeColor function for hashtag, url and userMentioned
private extension NSMutableAttributedString{
    func changeColor(keywords: [Twitter.Mention]?, color: UIColor) {
        if let allKeywords = keywords{
            for eachKeyword in allKeywords {
                addAttribute(NSForegroundColorAttributeName, value: color, range: eachKeyword.nsrange)
            }
        }
    }
}
