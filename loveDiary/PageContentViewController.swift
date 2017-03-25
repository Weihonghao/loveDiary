//
//  PageContentViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/17.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
//the content for page controller
class PageContentViewController: UIViewController {
    
    @IBOutlet weak var pageImageView: UIImageView!
    //the index to load photo from file system
    var pageIndex: Int? {
        didSet{
            //print("\(pageIndex)")
            //image = nil
            fetchImage()
        }
    }
    
    
    
    var myFileSystem = MyFileSystem()
    
    private var image: UIImage? {
        get{
            return pageImageView.image
        }
        set{
            pageImageView.image = newValue
        }
    }
    
    
    private func fetchImage() {
        //print("fetch Image")
        //print("\(pageIndex)")
        if let pNumber = pageIndex {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
