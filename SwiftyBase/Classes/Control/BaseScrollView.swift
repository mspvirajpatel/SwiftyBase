//
//  BaseScrollView.swift
//  Pods
//
//  Created by MacMini-2 on 07/09/17.
//
//

import Foundation
import UIKit

/**
 this is list of ScrollView Type which are suppored in BaseScrollView
 */
public enum BaseScrollViewType: Int {

    case vertical = 1 // Its for Scroll Verical
    case horizontal // ITs for Scroll Horizontal
    case both // ITs for Both Vertical and Horizontal Scroll
}
/**
 This is base class of UIScrollView. Using this, we can globalize proparty of UIScrollview as per type in whole application. Using this class, its will automattically add the content view in Scrollview as per type. so we don't need to every time content view and its constraint.
 */
open class BaseScrollView: UIScrollView, UIScrollViewDelegate {

    // MARK: - Attributes -
    /// This is containter View of Base ScrollView. Its automattically add to scrollview when we initialize it. Its Constraint also will be added.
    open var container: UIView!

    open var lastViewConstraint: NSLayoutConstraint!

    /// This is type of ScrollView. Default is Vertical.
    open var type: BaseScrollViewType = .vertical

    /// This is event block of ScrollView, its occure when scroollview did Scroll
    open var didScrollEvent: ScrollViewDidScrollEvent!

    // MARK: - Lifecycle -

    /// Here we override Init method of scrollVeiw and set Default Type Vertical
    public init() {
        super.init(frame: CGRect.zero)
        type = .vertical
        self.loadViewControls()
        self.setLayout()
    }

    /**
     Here we define the ScrollView init Method with SuperView object
     - parameter superView : Its object of ScrollView's superView. it can be nil. When not nil then scrollView will be added to this SuperView.
     */
    public init(superView: UIView?) {
        super.init(frame: CGRect.zero)

        type = .vertical
        self.loadViewControls()
        self.setLayout()

        if(superView != nil) {
            superView!.addSubview(self)
        }
    }

    /**
     Here we define the ScrollView init Method with SuperView object
     - parameter superView Its object of ScrollView's superView. it can be nil. When not nil then scrollView will be added to this SuperView.
     - parameter scrollType Type of The ScrollView
     */
    public init(scrollType: BaseScrollViewType, superView: UIView?) {
        super.init(frame: CGRect.zero)

        type = scrollType
        self.loadViewControls()
        self.setLayout()

        if(superView != nil) {
            superView!.addSubview(self)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!

    }

    override open func layoutSubviews() {
        super.layoutSubviews()
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit {

        if container != nil && container.superview != nil {
            container.removeFromSuperview()
            container = nil
        }

        didScrollEvent = nil
        lastViewConstraint = nil
    }

    // MARK: - Layout -
    /**
     This method is used for Initalize the scrollview's subcontrol when its initialized.
     */
    func loadViewControls() {
        self.translatesAutoresizingMaskIntoConstraints = false

        /*  container Allocation   */
        container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(container)
    }

    /**
     This method for Perform Layout Relate Operation of ScrollView when Its Initialized. Here Content View's Constraint will be added as per type.
     */
    func setLayout() {

        if(SystemConstants.hideLayoutArea) {
            container.backgroundColor = UIColor.black
        }

        var baseLayout: AppBaseLayout!
        baseLayout = AppBaseLayout()

        baseLayout.viewDictionary = ["container": container,
            "self": self]

        /*     container Layout     */

        switch type {
        case .vertical:

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container(==self)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container(==self@250)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            break

        case .horizontal:

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container(==self@250)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container(==self)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            break

        case .both:

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[container(==self@250)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[container(==self@250)]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            break
        }

        baseLayout.releaseObject()
        baseLayout = nil
    }

    // MARK: - Public Interface -

    public func setScrollViewContentSize() {

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            if(self!.lastViewConstraint != nil) {
                self!.removeConstraint(self!.lastViewConstraint)
            }

            var visibleSubView: UIView? = nil
            let subViewCount: Int = (self!.container.subviews.count)

            for i in stride(from: (subViewCount - 1), to: 0, by: -1) {
                visibleSubView = self!.container.subviews[i]
                if(visibleSubView?.isHidden == false) {
                    break
                }
            }

            self!.lastViewConstraint = NSLayoutConstraint.init(item: self!.container, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: visibleSubView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: 0.0)
            self!.addConstraint(self!.lastViewConstraint)
            self!.layoutSubviews()
        }
    }

    // MARK: - User Interaction -

    private func setScrollViewDidScrollEvent(_ event: @escaping ScrollViewDidScrollEvent) {
        didScrollEvent = event
    }

    // MARK: - Internal Helpers -



    // MARK: - UIScrollViewDelegate Methods -

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if(didScrollEvent != nil) {
            setScrollViewDidScrollEvent({ (scrollView, nil) in
            })
        }
    }
}
