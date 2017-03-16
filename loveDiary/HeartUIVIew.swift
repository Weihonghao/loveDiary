//
//  HeartUIVIew.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/16.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit
@IBDesignable


class HeartUIVIew: UIView {

    //@IBInspectable
    //var mouthCurvature: Double = 0.5 // 1.0 is full smile and -1.0 is full frown
    
    @IBInspectable
    var direction: Bool = true
    
    @IBInspectable
    var scale: CGFloat = 0.9
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0
    
    @IBInspectable
    var color: UIColor = UIColor.red
    
    private var HeartRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 3 * scale
    }
    
    private var HeartCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    
    private enum UpHeart {
        case left
        case right
    }
    
    
    private func pathForUp(_ upHeart: UpHeart) -> UIBezierPath
    {
        func centerOfEye(_ upHeart: UpHeart) -> CGPoint {
            let eyeOffset = HeartRadius / 2
            var heartCenter = HeartCenter
            heartCenter.x += ((upHeart == .left) ? -1 : 1) * eyeOffset
            return heartCenter
        }
        
        let upRadius = HeartRadius / 2
        let upCenter = centerOfEye(upHeart)
        
        let path: UIBezierPath
        path = UIBezierPath(arcCenter: upCenter, radius: upRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    
    
    private func pathForDown() -> UIBezierPath {
        let path = UIBezierPath(arcCenter: HeartCenter, radius: HeartRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: false)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        color.set()
        pathForDown().stroke()
        pathForUp(.left).stroke()
        pathForUp(.right).stroke()
    }
}
