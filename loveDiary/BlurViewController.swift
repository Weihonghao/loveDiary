//
//  BlurViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/16.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class BlurViewController: UIViewController {
    
    private var minZoomScale = 0.03
    private var maxZoomScale = 10.0
    
    var myFileSystem = MyFileSystem()
    
    @IBAction func printView(_ sender: UIBarButtonItem) {
        
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfoOutputType.general
        printInfo.jobName = "Print my image view"
        
        // Set up print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        
        // Assign a UIImage version of my UIView as a printing iten
        printController.printingItem = self.view.turnPicture()
        
        // Do it
        printController.present(from: self.view.frame, in: self.view, animated: true, completionHandler: nil)
    }
    
    
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {presentingViewController?.dismiss(animated: true)
    }
    
    
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
    
    fileprivate var imageView = UIImageView()
    
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
            imageView.sizeToFit()
            pictureScrollView?.contentSize = imageView.frame.size
            rescale() // rescale the image when it is first loaded
            whetherDidZoom = false
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
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame.size = CGSize(width: view.frame.width/2, height: view.frame.width/2)
        blurView.center = view.center
        view.addSubview(blurView)
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
        
        
        
        /*imageView.frame.size = CGSize(width: view.frame.width, height: view.frame.height)
         imageView.center = view.center
         view.addSubview(imageView)*/
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

extension BlurViewController : UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension UIView {
    func turnPicture() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
