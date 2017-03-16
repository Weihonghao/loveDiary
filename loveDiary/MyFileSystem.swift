//
//  MyFileSystem.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/15.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation


//
//  FileSystem.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/15.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import Foundation


class MyFileSystem {
    public func getDir(_ dir: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let dataPath = documentsDirectory + "/" + dir
        return dataPath
    }
    
    public func createDir(_ dir: String) {
        let dataPath = getDir(dir)
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    public func  checkDirExist(_ dir: String) -> Bool {
        let dataPath = getDir(dir)
        return FileManager.default.fileExists(atPath: dataPath)
    }
    
    public func createFile(_ dir: String) {
        let dataPath = getDir(dir)
        FileManager.default.createFile(atPath: dataPath, contents: nil, attributes: nil)
    }
    
    public func fileNumber(_ dir: String) -> Int {
        let dataPath = getDir(dir)
        do {
            let contentsOfPath =  try FileManager.default.contentsOfDirectory(at: NSURL(string: dataPath) as! URL, includingPropertiesForKeys: nil, options: [])
            return contentsOfPath.count
        } catch let err {
            print("\(err)")
        }
        return 0
    }
    
}


extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}
