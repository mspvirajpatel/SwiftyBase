//
//  AppBaseLayout.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

open class AppBaseLayout: NSObject {

    open var position_Top, position_Bottom: NSLayoutConstraint!
    open var position_Left, position_Right: NSLayoutConstraint!

    open var margin_Left, margin_Right: NSLayoutConstraint!
    open var size_Width, size_Height: NSLayoutConstraint!

    open var position_CenterX, position_CenterY: NSLayoutConstraint!

    open var control_H: Array<NSLayoutConstraint>!
    open var control_V: Array<NSLayoutConstraint>!

    open var viewDictionary: [String: AnyObject]!
    open var metrics: [String: CGFloat]!

    open var view: UIView!

    // MARK: - Lifecycle -

    public override init() {
        super.init()
    }

    public init(iView: UIView) {
        self.view = iView
    }

    // MARK: - Public Interface -
    open func setLeftRightConstraint(_ superView: UIView, control: UIView, space: CGFloat)
    {
        let dictionary: Dictionary = ["superView": superView, "control": control]
        let metrics: Dictionary = ["space": space]

        self.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-space-[control]-space-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: dictionary)
        superView.addConstraints(self.control_H)
    }


    open func expandViewInsideView(_ mainView: UIView) {

        self.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view])
        self.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: ["view": view])

        mainView.addConstraints(self.control_H)
        mainView.addConstraints(self.control_V)
    }

    open func expandView(_ containerView: UIView, insideView mainView: UIView) {

        let dictionary: Dictionary = ["containerView": containerView]

        self.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: dictionary)
        self.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: dictionary)

        mainView.addConstraints(self.control_H)
        mainView.addConstraints(self.control_V)
    }

    open func expandView(_ containerView: UIView, insideView mainView: UIView, betweenSpace space: CGFloat) {


        let dictionary: Dictionary = ["containerView": containerView]

        let metrics: Dictionary = ["space": space]
        self.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-space-[containerView]-space-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: dictionary)
        self.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-space-[containerView]-space-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: dictionary)

        mainView.addConstraints(self.control_H)
        mainView.addConstraints(self.control_V)
    }

    open func releaseObject() {
        position_Top = nil
        position_Left = nil
        position_Right = nil
        position_Bottom = nil
        position_CenterX = nil
        position_CenterY = nil
        size_Width = nil
        size_Height = nil
        control_H = nil
        control_V = nil
        margin_Left = nil
        margin_Right = nil

        if metrics != nil {
            metrics.removeAll()
        }

        if viewDictionary != nil {
            viewDictionary.removeAll()
        }
    }

    // MARK: - Internal Helpers -
}
