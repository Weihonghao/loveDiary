//
//  ImagePageViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/17.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class ImagePageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //var pageViewController : UIPageViewController!
    //This is for pagecontroller, we can swipe left and right to see all photos stored locally for the app
    var pageCount: Int = 0
    var myFileSystem = MyFileSystem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        pageCount = myFileSystem.fileNumber("myImage")
        print("pageCount \(pageCount)")
        createPageViewController()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //choose the index aforehand
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! PageContentViewController).pageIndex!
        index -= 1
        if index < 0 {
            return nil
        }
        return self.getPageContentController(index)
        
    }
    
    //choose the following index
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! PageContentViewController).pageIndex!
        index += 1
        if index >= pageCount {
            return nil
        }
        return self.getPageContentController(index)
    }
    
    //the number of pages
    public func presentationCount(for pageViewController: UIPageViewController) -> Int  {
        return pageCount
    }
    
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int{
        return 0
    }
    
    
    private func getPageContentController(_ contentPageIndex: Int) -> PageContentViewController? {
        
        if contentPageIndex < pageCount {
            let contentPageController = self.storyboard!.instantiateViewController(withIdentifier: "PageContentController") as! PageContentViewController
            //print("flag1")
            contentPageController.pageIndex = contentPageIndex
            //print("flag2")
            return contentPageController
        }
        return nil
    }
    
    
    private func createPageViewController() {
        
        if pageCount > 0 {
            let firstController = getPageContentController(0)!
            let startingViewControllers: NSArray = [firstController]
            self.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        
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
