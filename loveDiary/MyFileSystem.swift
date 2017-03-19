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
    //get the dir of file
    public func getDir(_ dir: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        let dataPath = documentsDirectory + "/" + dir
        return dataPath
    }
    
    //if not, create the folder
    public func createDir(_ dir: String) {
        let dataPath = getDir(dir)
        do {
            try FileManager.default.createDirectory(atPath: dataPath, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
    
    //check whether the folder exists or not
    public func  checkDirExist(_ dir: String) -> Bool {
        let dataPath = getDir(dir)
        return FileManager.default.fileExists(atPath: dataPath)
    }
    
    //create the file of given folder and directory
    public func createFile(_ dir: String) {
        let dataPath = getDir(dir)
        FileManager.default.createFile(atPath: dataPath, contents: nil, attributes: nil)
    }
    
    //the number of files under current directory
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
    
    //delete the file
    public func deleteFile(_ dir: String) {
        let dataPath = getDir(dir)
        print("herhhrhehehe \(dataPath)")
        do {
            try FileManager.default.removeItem(atPath: dataPath)
        } catch let err {
            print("\(err)")
        }
    }
}


extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}
