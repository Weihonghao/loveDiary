//
//  PhotoCollectionViewCell.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/15.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    //file manager
    var myFileSystem = MyFileSystem()
    //the number to load picture from nsfilesystem
    var photoNumber: Int? {
        didSet{
            image = nil
            fetchImage()
        }
    }
    
    private var image: UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
        }
    }
    
    private func fetchImage() {
        if let pNumber = photoNumber {
            let dir = "myImage/" + String(pNumber) + ".png"
            let imageURL = URL(fileURLWithPath: myFileSystem.getDir(dir))
            if true {
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let urlContents = try? Data(contentsOf: imageURL)
                    if let imageData = urlContents {
                        DispatchQueue.main.async {
                            self?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
