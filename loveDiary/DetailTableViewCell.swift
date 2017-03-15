//
//  DetailTableViewCell.swift
//  Smashtag
//
//  Created by WeiHonghao on 17/2/14.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit


// this tableviewcell is for the detail of an single tweet
class DetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pictureView: UIImageView!
    
    public var imageUrl: URL? {
        didSet{
            updateUI()
        }
    }
    
    // use dispatchQueue not to block the main thread
    private func updateUI() {
        //tweetTextLabel?.text = tweet?.text
        if let tweetImageUrl = imageUrl {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: tweetImageUrl)
                if let imageData = urlContents, tweetImageUrl == self?.imageUrl{
                    DispatchQueue.main.async {
                        self?.pictureView.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            pictureView.image = nil
        }
    }
}
