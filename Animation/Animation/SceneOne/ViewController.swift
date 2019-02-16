//
//  ViewController.swift
//  Animation
//
//  Created by dengjiangzhou on 2018/6/4.
//  Copyright © 2018年 dengjiangzhou. All rights reserved.
//

import UIKit
import CoreMotion



class ViewController: UIViewController {
    
    
    @IBOutlet weak var lidImageView: UIImageView!
    @IBOutlet weak var cupImageView: UIImageView!
    
    @IBOutlet weak var restartButton: UIButton!
    
    // vars
    
    let starNum = 10
    var animator: UIDynamicAnimator?
    lazy var motionManager = CMMotionManager()
    
    var timer: Timer?
    var dynamicItems = [UIView]()
    var gravity = UIGravityBehavior()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "星巴克， 星星坠落"
        restartStarAnimation()
        
    }
    
    
    
    
    
    
    
    @IBAction func restartStarAnimation(_ sender: UIButton) {
        restartStarAnimation()
    }
    
    
    
    private func restartStarAnimation(){
        if #available(iOS 10.0, *){
            stopAnimation()
            lidImageView.layer.anchorPoint = CGPoint(x: 0, y: 1)
            lidImageView.layer.position = CGPoint(x: lidImageView.frame.origin.x - 61 , y:  lidImageView.frame.origin.y + 66 )
            UIView.animate(withDuration: 0.5, animations: {
                self.lidImageView.transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
            })
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true, block: { __ in
                self.createStarFallAnimtion()
            })
        }
        
    }
    
    
    private func stopAnimation(){
        timer?.invalidate()
        animator?.removeAllBehaviors()
        
        for itemView in dynamicItems {
            itemView.removeFromSuperview()
        }
        
        dynamicItems.removeAll()
        
        motionManager.stopDeviceMotionUpdates()
        
    }
    
    
    private func createStarFallAnimtion(){
        restartButton.isHidden = true
        
        guard dynamicItems.count < starNum else {
            restartButton.isHidden = false
            timer?.invalidate()
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: { (deviceMotion, motionError) in
                let rotationAngel = atan2( deviceMotion!.gravity.x, deviceMotion!.gravity.y) - Double.pi/2
                // 通过 C 标准库 里面的， atan2 ， 正切函数，计算出来
                guard abs(rotationAngel) > 0.7 else {  return  }
                self.gravity.setAngle(CGFloat(rotationAngel), magnitude: 0.1)
            })
            UIView.animate(withDuration: 0.5, animations: {
                self.lidImageView.transform = CGAffineTransform.identity
            }, completion: { _ in
                self.lidImageView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                // 大量 使用 anchorPoint， 锚点
                
                self.lidImageView.layer.position = self.lidImageView.center
            })
            return
        }
        
        let starImageView = UIImageView.createStar()
        cupImageView.addSubview(starImageView)
        
        dynamicItems.append(starImageView)
        animator = UIDynamicAnimator(referenceView: cupImageView)
        gravity = UIGravityBehavior(items: dynamicItems)
        gravity.magnitude = 0.8
        
        let collisionTop = UICollisionBehavior(items: dynamicItems)
        let collisionLeft = UICollisionBehavior(items: dynamicItems)
        let collisionRight = UICollisionBehavior(items: dynamicItems)
        let collisionBottom = UICollisionBehavior(items: dynamicItems)
        
        
        let pointLeftTop = CGPoint(x: 6, y: 0)
        let pointRightTop = CGPoint(x: 116, y: 0)
        let pointLeftBottom = CGPoint(x: 22, y: 163)
        let pointRightBottom = CGPoint(x: 100, y: 163)
        
        collisionTop.addBoundary(withIdentifier: "boundaryTop" as NSCopying, from: pointLeftTop, to: pointRightTop)
        collisionLeft.addBoundary(withIdentifier: "boundaryLeft" as NSCopying, from: pointLeftTop, to: pointLeftBottom)
        collisionRight.addBoundary(withIdentifier: "boundaryRight" as NSCopying, from: pointRightBottom, to: pointRightTop)
        collisionBottom.addBoundary(withIdentifier: "boundaryBottom" as NSCopying, from: pointLeftBottom, to: pointRightBottom)
        
        let behavior = UIDynamicItemBehavior(items: dynamicItems)
        behavior.elasticity = 0.4
        animator?.addBehavior(gravity)
        animator?.addBehavior(collisionTop)
        animator?.addBehavior(collisionLeft)
        animator?.addBehavior(collisionRight)
        animator?.addBehavior(collisionBottom)
        animator?.addBehavior(behavior)
        
    }   // 尼玛的， 不优化， 见鬼了
    // 这代码， 真是 又丑， 又长， 又恶心， 有硬编码

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}












