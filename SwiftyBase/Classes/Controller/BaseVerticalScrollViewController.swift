//
//  BaseVerstical.swift
//  Pods
//
//  Created by MacMini-2 on 14/09/17.
//
//

import Foundation
import UIKit

public class BaseVerticalScrollViewController: UIViewController, ContainerViewControllerDelegate {
    public var topVc: UIViewController!
    public var middleVc: UIViewController!
    public var bottomVc: UIViewController!
    public var scrollView: UIScrollView!

    public class func verticalScrollVcWith(middleVc: UIViewController,
                                           topVc: UIViewController? = nil,
                                           bottomVc: UIViewController? = nil) -> BaseVerticalScrollViewController {
        let middleScrollVc = BaseVerticalScrollViewController()

        middleScrollVc.topVc = topVc
        middleScrollVc.middleVc = middleVc
        middleScrollVc.bottomVc = bottomVc

        return middleScrollVc
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view:
        setupScrollView()
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false

        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x, y: view.y, width: view.width, height: view.height)
        self.view.addSubview(scrollView)

        let scrollWidth: CGFloat = view.width
        var scrollHeight: CGFloat

        switch (topVc, bottomVc) {
        case (nil, nil):
            scrollHeight = view.height
            middleVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)

            addChild(middleVc)
            scrollView.addSubview(middleVc.view)
            middleVc.didMove(toParent: self)
        case (_?, nil):
            scrollHeight = 2 * view.height
            topVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)

            addChild(topVc)
            addChild(middleVc)

            scrollView.addSubview(topVc.view)
            scrollView.addSubview(middleVc.view)

            topVc.didMove(toParent: self)
            middleVc.didMove(toParent: self)

            scrollView.contentOffset.y = middleVc.view.frame.origin.y
        case (nil, _?):
            scrollHeight = 2 * view.height
            middleVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            bottomVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)

            addChild(middleVc)
            addChild(bottomVc)

            scrollView.addSubview(middleVc.view)
            scrollView.addSubview(bottomVc.view)

            middleVc.didMove(toParent: self)
            bottomVc.didMove(toParent: self)

            scrollView.contentOffset.y = 0
        default:
            scrollHeight = 3 * view.height
            topVc.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleVc.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            bottomVc.view.frame = CGRect(x: 0, y: 2 * view.height, width: view.width, height: view.height)

            addChild(topVc)
            addChild(middleVc)
            addChild(bottomVc)

            scrollView.addSubview(topVc.view)
            scrollView.addSubview(middleVc.view)
            scrollView.addSubview(bottomVc.view)

            topVc.didMove(toParent: self)
            middleVc.didMove(toParent: self)
            bottomVc.didMove(toParent: self)

            scrollView.contentOffset.y = middleVc.view.frame.origin.y
        }

        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
    }

    // MARK: - ContainerViewControllerDelegate Methods

    public func outerScrollViewShouldScroll() -> Bool {
        if scrollView.contentOffset.y < middleVc.view.frame.origin.y || scrollView.contentOffset.y > 2 * middleVc.view.frame.origin.y {
            return false
        } else {
            return true
        }
    }

}
