//
//  BaseDrawerMenuItem.swift
//  Pods
//
//  Created by MacMini-2 on 11/09/17.
//
//

import Foundation
import QuartzCore
import UIKit

open class BaseDrawerMenuItem: UIBarButtonItem {

    open var menuButton: AnimatedMenuButton

    open class AnimatedMenuButton: UIButton {

        lazy public var topCA: CAShapeLayer = CAShapeLayer()
        lazy var middle: CAShapeLayer = CAShapeLayer()
        lazy public var bottomCA: CAShapeLayer = CAShapeLayer()


        let shortStroke: CGPath = {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 3.5, y: 6))
            path.addLine(to: CGPoint(x: 22.5, y: 6))
            return path
        }()


        // MARK: - Initializers

        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        override convenience init(frame: CGRect) {
            self.init(frame: frame, strokeColor: UIColor.white)
        }

        public init(frame: CGRect, strokeColor: UIColor) {
            super.init(frame: frame)

            self.topCA.path = shortStroke
            self.middle.path = shortStroke
            self.bottomCA.path = shortStroke

            for layer in [self.topCA, self.middle, self.bottomCA] {
                layer.fillColor = nil
                layer.strokeColor = strokeColor.cgColor
                layer.lineWidth = 1
                layer.miterLimit = 2
                layer.lineCap = CAShapeLayerLineCap.square
                layer.masksToBounds = true

                if let path = layer.path, let strokingPath = CGPath(__byStroking: path, transform: nil, lineWidth: 1, lineCap: .square, lineJoin: .miter, miterLimit: 4) {
                    layer.bounds = strokingPath.boundingBoxOfPath
                }

                layer.actions = [
                    "opacity": NSNull(),
                    "transform": NSNull()
                ]

                self.layer.addSublayer(layer)
            }

            self.topCA.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.topCA.position = CGPoint(x: 23, y: 7)
            self.middle.position = CGPoint(x: 13, y: 13)

            self.bottomCA.anchorPoint = CGPoint(x: 1, y: 0.5)
            self.bottomCA.position = CGPoint(x: 23, y: 19)
        }

        open override func draw(_ rect: CGRect) {

            UIColor.white.setStroke()

            let context = UIGraphicsGetCurrentContext()
            context?.setShouldAntialias(false)

            let top = UIBezierPath()
            top.move(to: CGPoint(x: 3, y: 6.5))
            top.addLine(to: CGPoint(x: 23, y: 6.5))
            top.stroke()

            let middle = UIBezierPath()
            middle.move(to: CGPoint(x: 3, y: 12.5))
            middle.addLine(to: CGPoint(x: 23, y: 12.5))
            middle.stroke()

            let bottom = UIBezierPath()
            bottom.move(to: CGPoint(x: 3, y: 18.5))
            bottom.addLine(to: CGPoint(x: 23, y: 18.5))
            bottom.stroke()
        }
    }


    // MARK: - Initializers

    public override init() {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        self.menuButton.tintColor = UIColor.white
        super.init()
        self.customView = self.menuButton
    }

    public convenience init(target: AnyObject?, action: Selector) {
        self.init(target: target, action: action, menuIconColor: UIColor.white)
    }

    public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor) {
        self.init(target: target, action: action, menuIconColor: menuIconColor, animatable: true)
    }

    public convenience init(target: AnyObject?, action: Selector, menuIconColor: UIColor, animatable: Bool) {
        let menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26), strokeColor: menuIconColor)
        menuButton.addTarget(target, action: action, for: UIControl.Event.touchUpInside)
        self.init(customView: menuButton)

        self.menuButton = menuButton
    }

    public required init?(coder aDecoder: NSCoder) {
        self.menuButton = AnimatedMenuButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        super.init(coder: aDecoder)
        self.customView = self.menuButton
    }
}
