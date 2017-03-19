//
//  WebViewController.swift
//  Smashtag
//
//  Created by WeiHonghao on 17/2/16.
//  Copyright © 2017年 Stanford University. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {
    
    
    
    //the webview for safari
    
    @IBOutlet weak var webView: UIWebView! {
        didSet{
            webView?.delegate = self
        }
    }
    
    //action to take in browser, go back
    @IBAction func webGoBack(_ sender: Any) {
        webView?.goBack()
    }
    
    
    
    //url of the website
    public var webUrl: URL? {
        didSet {
            if view.window != nil { // if we're on screen
                fetchWeb()        // then fetch image
            }
        }
    }
    
    //try to fetch the website content
    private func fetchWeb() {
        if let tweetWebUrl = webUrl {
            webView?.loadRequest(URLRequest(url: tweetWebUrl))
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView?.scalesPageToFit = true
        fetchWeb()
        // Do any additional setup after loading the view.
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
