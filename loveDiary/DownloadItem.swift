//
//  DownloadItem.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/18.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation


class DownloadItem {
    //mainly for load method when  using  NSURLSession, sockets: Networking API
    func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        
        // use get method
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                    print("Success")
                }
                do {
                    try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch {
                }
                
            } else {
            }
        }
        task.resume()
    }
}
