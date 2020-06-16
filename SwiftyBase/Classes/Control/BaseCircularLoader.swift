//
//  BaseCircularLoader.swift
//  Pods
//
//  Created by MacMini-2 on 12/09/17.
//
//

import Foundation
import UIKit

open class BaseCircularLoader: UIView, CAAnimationDelegate {

    public let circlePathLayer = CAShapeLayer()
    public let circleRadius: CGFloat = 20.0

    open var progress: CGFloat {
        get {
            return circlePathLayer.strokeEnd
        }
        set {
            //print("New value \(newValue)")
            if (newValue > 1) {
                circlePathLayer.strokeEnd = 1
            } else if (newValue < 0) {
                circlePathLayer.strokeEnd = 0
            } else {
                circlePathLayer.strokeEnd = newValue
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configure()
    }

    open func configure() {
        circlePathLayer.frame = bounds
        circlePathLayer.lineWidth = 2
        circlePathLayer.fillColor = UIColor.clear.cgColor
        circlePathLayer.strokeColor = UIColor.red.cgColor
        layer.addSublayer(circlePathLayer)
        backgroundColor = UIColor.white
        progress = 0
    }

    public func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = circlePathLayer.bounds.midX - circleFrame.midX
        circleFrame.origin.y = circlePathLayer.bounds.midY - circleFrame.midY
        return circleFrame
    }

    open func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        circlePathLayer.frame = bounds
        circlePathLayer.path = circlePath().cgPath
    }

    public func reveal() {
        backgroundColor = UIColor.clear
        progress = 1
        circlePathLayer.removeAnimation(forKey: "strokeEnd")
        circlePathLayer.removeFromSuperlayer()
        superview?.layer.mask = circlePathLayer

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let finalRadius = sqrt((center.x * center.x) + (center.y * center.y))
        let radiusInset = finalRadius - circleRadius
        let outerRect = circleFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
        //let outerRect = circleFrame().insetBy(dx: -radiusInset, dy: -radiusInset)
        let toPath = UIBezierPath(ovalIn: outerRect).cgPath

        //2
        let fromPath = circlePathLayer.path
        let fromLineWidth = circlePathLayer.lineWidth

        //3
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        circlePathLayer.lineWidth = 2 * finalRadius
        circlePathLayer.path = toPath
        CATransaction.commit()

        //4
        let lineWidthAnimation = CABasicAnimation(keyPath: "lineWidth")
        lineWidthAnimation.fromValue = fromLineWidth
        lineWidthAnimation.toValue = 2 * finalRadius
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = fromPath
        pathAnimation.toValue = toPath

        //5
        let groupAnimation = CAAnimationGroup()
        groupAnimation.duration = 0.0001
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        groupAnimation.animations = [pathAnimation, lineWidthAnimation]
        groupAnimation.delegate = self
        circlePathLayer.add(groupAnimation, forKey: "strokeWidth")
    }

    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        superview?.layer.mask = nil
    }
}
