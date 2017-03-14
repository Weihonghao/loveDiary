//
//  ImageCollectionViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/14.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController {
    
    
    
    ///取得的资源结果，用了存放的PHAsset
    var assetsFetchResults:PHFetchResult<PHAsset>!
    
    ///缩略图大小
    var assetGridThumbnailSize:CGSize!
    
    /// 带缓存的图片管理对象
    var imageManager:PHCachingImageManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        //则获取所有资源
        let allPhotosOptions = PHFetchOptions()
        //按照创建时间倒序排列
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",
                                                             ascending: false)]
        //只获取图片
        allPhotosOptions.predicate = NSPredicate(format: "mediaType = %d",
                                                 PHAssetMediaType.image.rawValue)
        assetsFetchResults = PHAsset.fetchAssets(with: PHAssetMediaType.image,
                                                 options: allPhotosOptions)
        
        // 初始化和重置缓存
        self.imageManager = PHCachingImageManager()
        self.imageManager.stopCachingImagesForAllAssets()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale ,
                                        height:cellSize.height*scale)
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
    
    /*override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }*/
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.assetsFetchResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageViewCell", for: indexPath)  as! ImageCollectionViewCell
        print("return cell")
        let asset = self.assetsFetchResults[indexPath.row]
        //获取缩略图
        self.imageManager.requestImage(
            for: asset,
            targetSize: assetGridThumbnailSize,
            contentMode: PHImageContentMode.aspectFill,
            options: nil) { (image, info) in
                cell.imageView.image = image
                cell.titleLabel.text = "\(indexPath.item + 1)"
                print("image here \(image)")
                // Configure the cell
        }
        return cell
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
