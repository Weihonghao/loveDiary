//
//  PhotoCollectionViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/15.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "ImageCell"

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //file manager
    var myFileSystem = MyFileSystem()
    
    //we store all constants in a struct to make the code more concise
    private struct Constants {
        static let reuseIdentifier = "ImageCell"
        static let sectionInsets = UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)
        static let itemsPerRow: CGFloat = 2
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Photos Stored"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //return the size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = Constants.sectionInsets.left * ( Constants.itemsPerRow + 1)
        let availabelWidth = view.frame.width - paddingSpace
        let widthPerItem = availabelWidth / Constants.itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //return the section edge Insects
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.sectionInsets
    }
    
    //return the edge
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.sectionInsets.left
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "PhotoHeader", for: indexPath) as! PhotoCollectionReusableView
            headerView.photoHeaderLabel.text =  "photos downloaded"
            return headerView
        default:
            assert(false, "unexpected")
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    //one section
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    //depending on the number of file under given directory
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        let number = myFileSystem.fileNumber("myImage")
        print("cell number \(number)")
        return number
    }
    
    //return the cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = UIColor.black
        // Configure the cell
        if let imageCell = cell as? PhotoCollectionViewCell {
            imageCell.photoNumber = indexPath.row
        }
        return cell
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let scrollViewController = destinationViewController as? BlurViewController, let currentCell = sender as? PhotoCollectionViewCell {
            //Though we only have one segue, we still use identifier
            if segue.identifier == "showLarge" {
                scrollViewController.photoNumber = currentCell.photoNumber
            }
        }
    }
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
