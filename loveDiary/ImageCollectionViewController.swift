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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //根据单元格的尺寸计算我们需要的缩略图大小
        let scale = UIScreen.main.scale
        let cellSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        assetGridThumbnailSize = CGSize(width:cellSize.width*scale ,
                                        height:cellSize.height*scale)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.resetCachedAssets()
    }
    
    //重置缓存
    func resetCachedAssets(){
        self.imageManager.stopCachingImagesForAllAssets()
    }
    
    // CollectionView行数
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.assetsFetchResults.count
    }
    
    // 获取单元格
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // storyboard里设计的单元格
        let identify:String = "DesignViewCell"
        // 获取设计的单元格，不需要再动态添加界面元素
        let cell = (self.collectionView?.dequeueReusableCell(
            withReuseIdentifier: identify, for: indexPath))! as! ImageCollectionViewCell //UICollectionViewCell
        
        let asset = self.assetsFetchResults[indexPath.row]
        //获取缩略图
        self.imageManager.requestImage(for: asset, targetSize: assetGridThumbnailSize,
                                       contentMode: PHImageContentMode.aspectFill,
                                       options: nil) { (image, nfo) in
                                        (cell.imageView)
                                            .image = image
                                        //print(image)
        }
        return cell
    }
    
    // 单元格点击响应
    /*override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let myAsset = self.assetsFetchResults[indexPath.row]
        
        //这里不使用segue跳转（建议用segue跳转）
        let detailViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "detail")
            as! ImageDetailViewController
        detailViewController.myAsset = myAsset
        
        // navigationController跳转到detailViewController
        self.navigationController!.pushViewController(detailViewController,
                                                      animated:true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/
}
