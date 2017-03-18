//
//  HeartViewController.swift
//  loveDiary
//
//  Created by WeiHonghao on 17/3/16.
//  Copyright © 2017年 WeiHonghao. All rights reserved.
//

import UIKit

class HeartViewController: UIViewController, UIPopoverPresentationControllerDelegate {
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
            
            /*let tapRecognizer = UITapGestureRecognizer(target: heartView, action: #selector(HeartUIVIew.doubleTapChangeDirection(byReactingTo:)))
             tapRecognizer.numberOfTapsRequired = 2
             heartView.addGestureRecognizer(tapRecognizer)*/
            
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(beatHeart))
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
    
    
    
    /*private func updateUI()
     {
     
     heartView?.heartCurvature = heartElementCurvature ?? 0.0
     heartView?.direction = heartElementDirection ?? true
     }*/
    
    /*var heartElementDirection: Bool?
     var heartElementRadius: CGFloat?
     var heartElementCenter: CGPoint?
     var heartElementCurvature: Double?*/
    
    
    private struct HeartBeat {
        static let scale = CGFloat(1.5)                 // radians
        static let segmentDuration: TimeInterval = 0.5  // each head shake has 3 segments
    }
    
    private func zoomHeart(by size: CGFloat) {
        heartView.transform = heartView.transform.scaledBy(x: size, y: size)
    }
    
    let squareSize = HeartBeat.scale * HeartBeat.scale
    
    
    
    @objc private func beatHeart() {
            /*UIView.animate(withDuration: <#T##TimeInterval#>, delay: <#T##TimeInterval#>, options: <#T##UIViewAnimationOptions#>, animations: <#T##() -> Void#>, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)*/
            UIView.animate(
                withDuration: HeartBeat.segmentDuration,
                animations: { self.zoomHeart(by: HeartBeat.scale) },
                completion: { finished in
                    if finished {
                        UIView.animate(
                            withDuration: HeartBeat.segmentDuration,
                            
                            animations: { self.zoomHeart(by: 1.0 / self.squareSize) },
                            completion: { finished in
                                if finished {
                                    UIView.animate(
                                        withDuration: HeartBeat.segmentDuration,
                                        animations: { self.zoomHeart(by: HeartBeat.scale) }
                                    )
                                }
                        }
                        )
                    }
            }
            )
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        //if it a navigationController, turn it to a UIcontroller
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        //if let popoverViewController = destinationViewController {
            //as? UITableViewController, let _ = sender as? TweetTableViewCell {
            //Though we only have one segue, we still use identifier
        let popoverViewController = destinationViewController
            if segue.identifier == "popOverMenu" {
                print("fuck pop up")
                popoverViewController.modalPresentationStyle = UIModalPresentationStyle.popover
                popoverViewController.popoverPresentationController!.delegate = self
            
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
        
    
}
