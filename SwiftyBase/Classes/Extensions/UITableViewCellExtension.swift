//
//  UITableViewCellExtension.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

extension UITableViewCell {
    func shake(duration: CFTimeInterval = 0.3, pathLength: CGFloat = 15) {
        let position: CGPoint = self.center
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x:position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x:position.x+pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x-pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x+pathLength, y:position.y))
        path.addLine(to: CGPoint(x:position.x, y:position.y))
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }
}
