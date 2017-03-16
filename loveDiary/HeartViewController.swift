//
//  HeartViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/16.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController {
    /*var expression = FacialExpression(eyes: .open, mouth: .neutral) {
        didSet {
            updateUI()
        }
    }*/
    
    
    
    @IBOutlet weak var heartView: HeartUIVIew!{
        didSet {
            let handler = #selector(HeartUIVIew.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: heartView, action: handler)
            heartView.addGestureRecognizer(pinchRecognizer)
            
            /*let panRecognizer = UIPanGestureRecognizer(target: heartView, action: #selector(HeartUIVIew.panMoveOrigin(byReactingTo:)))
            heartView.addGestureRecognizer(panRecognizer)*/
            
            let tapRecognizer = UITapGestureRecognizer(target: heartView, action: #selector(HeartUIVIew.doubleTapChangeDirection(byReactingTo:)))
            tapRecognizer.numberOfTapsRequired = 2
            heartView.addGestureRecognizer(tapRecognizer)
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: heartView, action: #selector(HeartUIVIew.increaseCurve))
            swipeUpRecognizer.direction = .up
            heartView.addGestureRecognizer(swipeUpRecognizer)
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: heartView, action: #selector(HeartUIVIew.decreaseCurve))
            swipeDownRecognizer.direction = .down
            heartView.addGestureRecognizer(swipeDownRecognizer)
            //updateUI()
        }
    }
    

    
    private func updateUI()
    {
        
        heartView?.heartCurvature = heartElementCurvature ?? 0.0
        heartView?.direction = heartElementDirection ?? true
    }
    
        var heartElementDirection: Bool?
        var heartElementRadius: CGFloat?
        var heartElementCenter: CGPoint?
        var heartElementCurvature: Double?

}
