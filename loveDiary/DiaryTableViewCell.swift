//
//  DiaryTableViewCell.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/12.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class DiaryTableViewCell: UITableViewCell {
    
    //@IBOutlet weak var profileImage: UIImageView!
    //display the date
    @IBOutlet weak var diaryDateLabel: UILabel!
    //display the location
    @IBOutlet weak var diaryLocationLabel: UILabel!
    //display user's screenName
    @IBOutlet weak var userLabel: UILabel!
    //display the diary contents of the event
    @IBOutlet weak var diaryTextLabel: UILabel!
    
    
    var diary: Diary? { didSet { updateUI() } }
    
    //update UI
    private func updateUI() {
        //profileImage = nil
        //diaryDateLabel.text = diary?.date
        diaryLocationLabel.text = diary?.location
        diaryTextLabel.text = diary?.text
        userLabel.text = diary?.user.screenName
        
        diaryDateLabel.text = diary?.date
        
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
