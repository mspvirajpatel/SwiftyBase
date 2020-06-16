//
//  BaseScrollViewViewController.swift
//  Pods
//
//  Created by MacMini-2 on 14/09/17.
//
//

import Foundation

import UIKit

public protocol ContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

public class BaseScrollViewController: UIViewController, UIScrollViewDelegate {

    public var topVc: UIViewController?
    public var leftVc: UIViewController!
    public var middleVc: UIViewController!
    public var rightVc: UIViewController!
    public var bottomVc: UIViewController?

    public var directionLockDisabled: Bool!

    public var horizontalViews = [UIViewController]()
    public var veritcalViews = [UIViewController]()

    public var initialContentOffset = CGPoint() // scrollView initial offset
    public var maximumWidthFirstView: CGFloat = 0

    public var middleVertScrollVc: BaseVerticalScrollViewController!
    public var scrollView: UIScrollView!
    public var delegate: ContainerViewControllerDelegate?

    public class func containerViewWith(_ leftVC: UIViewController,
                                        middleVC: UIViewController,
                                        rightVC: UIViewController,
                                        topVC: UIViewController? = nil,
                                        bottomVC: UIViewController? = nil,
                                        directionLockDisabled: Bool? = false) -> BaseScrollViewController {
        let container = BaseScrollViewController()

        container.directionLockDisabled = directionLockDisabled

        container.topVc = topVC
        container.leftVc = leftVC
        container.middleVc = middleVC
        container.rightVc = rightVC
        container.bottomVc = bottomVC
        return container
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }

    func setupVerticalScrollView() {
        middleVertScrollVc = BaseVerticalScrollViewController.verticalScrollVcWith(middleVc: middleVc,
                                                                                   topVc: topVc,
                                                                                   bottomVc: bottomVc)
        delegate = middleVertScrollVc
    }

    func setupHorizontalScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false

        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )

        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )

        self.view.addSubview(scrollView)

        let scrollWidth = 3 * view.width
        let scrollHeight = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)

        leftVc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: view.width,
                                   height: view.height
        )

        middleVertScrollVc.view.frame = CGRect(x: view.width,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )

        rightVc.view.frame = CGRect(x: 2 * view.width,
                                    y: 0,
                                    width: view.width,
                                    height: view.height
        )

        addChild(leftVc)
        addChild(middleVertScrollVc)
        addChild(rightVc)

        scrollView.addSubview(leftVc.view)
        scrollView.addSubview(middleVertScrollVc.view)
        scrollView.addSubview(rightVc.view)

        leftVc.didMove(toParent: self)
        middleVertScrollVc.didMove(toParent: self)
        rightVc.didMove(toParent: self)

        scrollView.contentOffset.x = middleVertScrollVc.view.frame.origin.x
        scrollView.delegate = self
    }


    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)

            self.scrollView!.setContentOffset(newOffset, animated: false)
        }
        if maximumWidthFirstView != 0
            {
            if scrollView.contentOffset.x < maximumWidthFirstView
                {
                scrollView.isScrollEnabled = false
                let newOffset = CGPoint(x: maximumWidthFirstView, y: self.initialContentOffset.y)

                self.scrollView!.setContentOffset(newOffset, animated: false)
                scrollView.isScrollEnabled = true

            }
        }

    }

}
