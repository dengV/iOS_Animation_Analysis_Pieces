//
//  StarImageView.swift
//  Animation
//
//  Created by dengjiangzhou on 2018/6/4.
//  Copyright © 2018年 dengjiangzhou. All rights reserved.
//

import UIKit

class StarImageView: UIImageView {

    override var collisionBoundsType: UIDynamicItemCollisionBoundsType{
        return .ellipse
    }

}





extension UIImageView{
    static func createStar() -> UIImageView{
        let starImageView = StarImageView(image: UIImage(named: "MSRInfo_Main_star_01") )
        let positionX = CGFloat(arc4random_uniform(75) + 7)
        starImageView.frame = CGRect(x: positionX, y: 0, width: 24, height: 24)
        return starImageView
    }
    
}
