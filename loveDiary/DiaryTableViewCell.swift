//
//  DiaryTableViewCell.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var diaryDateLabel: UILabel!
    
    @IBOutlet weak var diaryLocationLabel: UILabel!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var diaryTextLabel: UILabel!
    
    
    var diary: Diary? { didSet { updateUI() } }
    
    
    private func updateUI() {
        profileImage = nil
        //diaryDateLabel.text = diary?.date
        diaryLocationLabel.text = diary?.location
        diaryTextLabel.text = diary?.text
        userLabel.text = diary?.user.screenName
        
        diaryDateLabel.text = diary?.date
        
        /*if let created = diary?.date {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            diaryDateLabel.text = formatter.string(from: created)
        } else {
            diaryDateLabel?.text = nil
        }*/
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
