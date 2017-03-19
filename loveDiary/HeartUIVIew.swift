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
    //this class is mainly for gesture and painting
    var axesOriginValue: CGPoint? = nil
    
    @IBInspectable
    var heartCurvature: Double = 0.6 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var direction: Bool = true { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var color: UIColor = UIColor.red { didSet { setNeedsDisplay() } }
    
    //@IBInspectable
    //var centerOffset: CGPoint = CGPoint(x:0.0, y:0.0) { didSet { setNeedsDisplay() } }
    
    
    //radius
    var HeartRadius: CGFloat {
        return min(bounds.size.width, bounds.size.height) / 3 * scale
    }
    
    //center
    var HeartCenter: CGPoint {
        get {
            return axesOriginValue ?? CGPoint(x: bounds.midX, y: bounds.midY)
        }
        set {
            axesOriginValue = newValue
            setNeedsDisplay()
        }
    }
    
    
    //the upper part of heart
    private enum UpHeart {
        case left
        case right
    }
    
    
    //change scale when gesture pinch used
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed,.ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    //change origin when gesture pan is used
    func panMoveOrigin(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        HeartCenter = panRecognizer.location(in: panRecognizer.view)
    }
    
    
    //double click to change the direction
    func doubleTapChangeDirection(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            //HeartCenter = tapRecognizer.location(in: tapRecognizer.view)
            if direction == true {
                direction = false
            } else {
                direction = true
            }
        }
    }
    
    func increaseCurve() {
        let directionDouble:Double = direction ? 1.0 : -1.0
        heartCurvature -= directionDouble * 0.1
    }
    
    func decreaseCurve() {
        let directionDouble:Double = direction ? 1.0 : -1.0
        heartCurvature += directionDouble * 0.1
    }
    
    //use of UIbezierpath
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
        path = UIBezierPath(arcCenter: upCenter, radius: upRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: (direction != true))
        
        path.lineWidth = lineWidth
        
        return path
    }
    
    
    
    /*private func pathForDown() -> UIBezierPath {
     let path = UIBezierPath(arcCenter: HeartCenter, radius: HeartRadius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
     path.lineWidth = lineWidth
     return path
     }*/
    
    private struct Ratios {
        /*static let skullRadiusToEyeOffset: CGFloat = 3
         static let skullRadiusToEyeRadius: CGFloat = 10
         static let skullRadiusToMouthWidth: CGFloat = 1
         static let skullRadiusToMouthHeight: CGFloat = 3*/
        static let heartRadiusToDownOffset: CGFloat = 1.5
        static let heartRadiusToDownHeight: CGFloat = 0.7
    }
    
    
    //path for the down part curve of heart
    private func pathForDown() -> UIBezierPath
    {
        let directionInt:CGFloat = direction ? 1.0 : -1.0
        let downWidth = HeartRadius
        let downHeight = HeartRadius / Ratios.heartRadiusToDownHeight
        //let mouthOffset = HeartRadius / Ratios.heartRadiusToDownOffset
        
        let downRect = CGRect(
            x: HeartCenter.x - downWidth,
            y: HeartCenter.y,
            width: 2 * downWidth,
            height: 2 *  downHeight
        )
        
        let smileOffset = CGFloat(max(0, min(heartCurvature, 1))) * downRect.height
        
        let start = CGPoint(x: downRect.minX, y: downRect.minY)
        let end = CGPoint(x: downRect.maxX, y: downRect.minY)
        let cp1 = CGPoint(x: start.x + downRect.width / 3, y: start.y + directionInt * smileOffset)
        let cp2 = CGPoint(x: end.x - downRect.width / 3, y: start.y + directionInt * smileOffset)
        
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
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
