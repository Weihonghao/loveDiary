//
//  pictureViewController.swift
//  Smashtag
//
//  Created by WeiHonghao on 17/2/15.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

class pictureViewController: UIViewController {
    private var minZoomScale = 0.03
    private var maxZoomScale = 10.0
    
    
    @IBOutlet weak var pictureScrollView: UIScrollView! {
        didSet {
            // to zoom we have to handle viewForZooming(in scrollView:)
            pictureScrollView.delegate = self
            // and we must set our minimum and maximum zoom scale
            pictureScrollView.minimumZoomScale = CGFloat(minZoomScale)
            pictureScrollView.maximumZoomScale = CGFloat(maxZoomScale)
            // most important thing to set in UIScrollView is contentSize
            pictureScrollView.contentSize = imageView.frame.size
            pictureScrollView.addSubview(imageView)
        }
    }
    
    public var imageUrl: URL? {
        didSet {
            image = nil
            if view.window != nil { // if we're on screen
                fetchImage()        // then fetch image
            }
        }
    }
    
    //use dispatchQueue not to block the main thread
    private func fetchImage() {
        if let tweetImageUrl = imageUrl {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let urlContents = try? Data(contentsOf: tweetImageUrl)
                if let imageData = urlContents, tweetImageUrl == self?.imageUrl{
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            image = nil
        }
    }
    
    
    fileprivate var imageView = UIImageView()
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            //print("here is correct")
            imageView.sizeToFit()
            pictureScrollView?.contentSize = imageView.frame.size
            rescale() // rescale the image when it is first loaded
            whetherDidZoom = false
        }
    }
    
    private var whetherDidZoom  = false
    
    
    // we only need to know whehter it has been zoomed in/out or not
    private func scrollViewDidZoom(_ scrollView: UIScrollView) {
        whetherDidZoom = true
    }
    
    // rescale the image so there should be no more white space around it
    private func rescale() {
        //we add these indicator, so that before the picture is zoomed in or out, the picture would be automatically rescaled.
        if whetherDidZoom == false {
            if let sview = pictureScrollView, image != nil {
                sview.zoomScale = max(sview.bounds.size.width / (image?.size.width)!, sview.bounds.size.height / (image?.size.height)!)
                self.automaticallyAdjustsScrollViewInsets = false
                whetherDidZoom = true
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pictureScrollView.addSubview(imageView)
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil { // we're about to appear on screen so, if needed,
            fetchImage()  // fetch image
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


extension pictureViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
