//
//  BaseSegment.swift
//  Pods
//
//  Created by MacMini-2 on 07/09/17.
//
//

import Foundation
import UIKit

public typealias SegmentTabbedEvent = (_ index: Int) -> ()

open class BaseSegment: UIView {

    // MARK: - Attributes -

    open var segmentViewHeight: CGFloat = 50.0
    open var tabbedEventBlock: SegmentTabbedEvent?

    open var KSegementSelectedTitleColor = AppColor.segmentSelectedTitle.value
    open var KSegementSelectedBackgroundColor = AppColor.segmentSelectedBG.value

    open var KSegementDeselectedTitleColor = AppColor.segmentTitle.value
    open var KSegementBackgroundColor = AppColor.segmentBG.value

    open var KSegmentBorderColor = AppColor.segmentBorder.value
    open var KSegmentBorderWidth: CGFloat = 2.0

    open var kSegmentButtonFont = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h3) : .standard(.h4)).instance

    open var KhighlightBackgroundColor = AppColor.segmentSelectedTitle.withAlpha(0.1)

    // MARK: - Lifecycle -

    public init(titleArray: [String], iSuperView: UIView) {
        super.init(frame: CGRect.zero)

        self.translatesAutoresizingMaskIntoConstraints = false
        iSuperView.addSubview(self)

        self.loadViewWithTitleArray(titleArray)
        self.setViewLayout()
    }

    public init(titleArray: [String], iSuperView: UIView, height: CGFloat) {
        super.init(frame: CGRect.zero)

        segmentViewHeight = height

        self.translatesAutoresizingMaskIntoConstraints = false
        iSuperView.addSubview(self)

        self.loadViewWithTitleArray(titleArray)
        self.setViewLayout()

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        for button in self.subviews {
            if button.tag == 0 {
                button.setBottomBorder(KSegmentBorderColor, width: KSegmentBorderWidth)
            }

        }


    }

    deinit {

    }

    // MARK: - Layout -

    func loadViewWithTitleArray(_ titleArray: [String]) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = false


        var segementButtonTag: Int = 0

        for titleString in titleArray {

            let segementButton: UIButton = UIButton(type: .custom)
            segementButton.translatesAutoresizingMaskIntoConstraints = false
            segementButton.backgroundColor = KSegementBackgroundColor
            self.addSubview(segementButton)
            segementButton.clipsToBounds = true

            segementButton.titleLabel?.lineBreakMode = .byWordWrapping
            segementButton.titleLabel?.textAlignment = .center

            segementButton.setTitle(titleString, for: UIControl.State())

            segementButton.titleLabel?.font = kSegmentButtonFont
            segementButton.setTitleColor(KSegementDeselectedTitleColor, for: UIControl.State())
            segementButton.tag = segementButtonTag
            segementButton.addTarget(self, action: #selector(segmentTabbed), for: .touchUpInside)

            segementButtonTag = segementButtonTag + 1

            segementButton.addTarget(self, action: #selector(buttonTouchUpInsideAction), for: .touchUpInside)
            segementButton.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchUpOutside)
            segementButton.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchCancel)
            segementButton.addTarget(self, action: #selector(buttonTouchDownAction), for: .touchDown)


        }
    }

    func setViewLayout() {

        var segementSubView, prevSegementSubView: UIView?
        var segementSubViewDictionary: [String: AnyObject]?
        var segementSubViewConstraints: Array<NSLayoutConstraint>?

        var control_H, control_V: Array<NSLayoutConstraint>?
        let viewDictionary = ["BBSegmentView": self]
        let metrics = ["BBSegmentViewHeight": segmentViewHeight]

        control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[BBSegmentView(>=0)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: viewDictionary)

        control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[BBSegmentView(BBSegmentViewHeight)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: viewDictionary)

        self.addConstraints(control_H!)
        self.addConstraints(control_V!)

        let segementSubViewCount = self.subviews.count
        prevSegementSubView = nil

        for i in 0...(segementSubViewCount - 1) {

            segementSubView = self.subviews[i]
            if(prevSegementSubView == nil) {
                segementSubViewDictionary = ["segementSubView": segementSubView!]

            } else {
                segementSubViewDictionary = ["segementSubView": segementSubView!,
                    "prevSegementSubView": prevSegementSubView!]
            }

            segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[segementSubView]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: segementSubViewDictionary!)
            self.addConstraints(segementSubViewConstraints!)

            segementSubViewConstraints = nil

            if(segementSubViewCount > 2) {

                switch i {

                case 0:

                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[segementSubView]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: segementSubViewDictionary!)

                    break

                case (segementSubViewCount - 1):

                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)

                    break

                default:

                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)

                    break
                }


            } else {

                switch i {

                case 0:

                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[segementSubView]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: segementSubViewDictionary!)

                    break

                case (segementSubViewCount - 1):

                    segementSubViewConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[prevSegementSubView][segementSubView(==prevSegementSubView)]|", options: [.alignAllTop, .alignAllBottom], metrics: nil, views: segementSubViewDictionary!)

                    break

                default:
                    break
                }

            }

            prevSegementSubView = segementSubView
            self.addConstraints(segementSubViewConstraints!)

            segementSubViewConstraints = nil
            segementSubViewDictionary = nil
            segementSubView = nil

        }

        self.layoutSubviews()
    }

    // MARK: - Public Interface -

    public func setTitleOnSegment(_ titleArray: [String]) {

        if(titleArray.count <= self.subviews.count && titleArray.count != 0) {

            var i: Int = 0
            for titleString in titleArray {

                let button: UIButton = self.subviews[i] as! UIButton
                button.setTitle(titleString, for: UIControl.State())

                i = i + 1
            }

        }

        self.layoutIfNeeded()
        self.layoutSubviews()

    }

    public func setSegmentTabbedEvent(_ iTabbedEventBlock: @escaping SegmentTabbedEvent) {
        tabbedEventBlock = iTabbedEventBlock
    }

    public func setSegementSelectedAtIndex(_ index: Int) {
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }

            self!.layoutSubviews()
            self!.layoutIfNeeded()

            let subViewCount = self!.subviews.count
            if(index < subViewCount) {

                let currentButton: UIButton = self!.subviews[index] as! UIButton
                currentButton.setBottomBorder(self!.KSegmentBorderColor, width: self!.KSegmentBorderWidth)
                currentButton.setTitleColor(self!.KSegementSelectedTitleColor, for: UIControl.State())

                for view in self!.subviews {

                    let button: UIButton = view as! UIButton

                    if(button.tag != currentButton.tag) {
                        button.setTitleColor(self!.KSegementDeselectedTitleColor, for: UIControl.State())
                        button.setBottomBorder(UIColor.clear, width: self!.KSegmentBorderWidth)
                    }
                }
            }
        }
    }

    // MARK: - User Interaction -

    @objc public func segmentTabbed(_ sender: AnyObject) {
        let currentButton: UIButton = (sender as? UIButton)!
        currentButton.setBottomBorder(KSegmentBorderColor, width: KSegmentBorderWidth)
        currentButton.setTitleColor(KSegementSelectedTitleColor, for: UIControl.State())

        for view in self.subviews {

            let button: UIButton = view as! UIButton

            if(button.tag != currentButton.tag) {

                button.setTitleColor(KSegementDeselectedTitleColor, for: UIControl.State())
                button.setBottomBorder(UIColor.clear, width: KSegmentBorderWidth)
            }
        }

        if(tabbedEventBlock != nil) {
            tabbedEventBlock!((currentButton.tag))
        }
    }

    // MARK: - Internal Helpers -
    //Only for button touch Effect

    @objc private func buttonTouchUpInsideAction(_ sender: UIButton) {
        sender.backgroundColor = KSegementBackgroundColor
    }
    @objc private func buttonTouchDownAction(_ sender: UIButton) {
        sender.backgroundColor = KhighlightBackgroundColor
    }

    @objc private func buttonTouchUpOutsideAction(_ sender: UIButton) {
        sender.backgroundColor = KSegementBackgroundColor
    }


}
