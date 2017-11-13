//
//  UIScrollViewExtension.swift
//  Pods
//
//  Created by MacMini-2 on 04/09/17.
//
//

import Foundation
#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif

public extension UIScrollView {
    fileprivate struct AssociatedKeys {
        static var kKeyScrollViewVerticalIndicator = "_verticalScrollIndicator"
        static var kKeyScrollViewHorizontalIndicator = "_horizontalScrollIndicator"
    }
    
    ///  YES if the scrollView's offset is at the very top.
    public var isAtTop: Bool {
        get { return self.contentOffset.y == 0.0 ? true : false }
    }
    
    ///  YES if the scrollView's offset is at the very bottom.
    public var isAtBottom: Bool {
        get {
            let bottomOffset = self.contentSize.height - self.bounds.size.height
            return self.contentOffset.y == bottomOffset ? true : false
        }
    }
    
    ///  YES if the scrollView can scroll from it's current offset position to the bottom.
    public var canScrollToBottom: Bool {
        get { return self.contentSize.height > self.bounds.size.height ? true : false }
    }
    
    /// The vertical scroll indicator view.
    public var verticalScroller: UIView {
        get {
            if (objc_getAssociatedObject(self, #function) == nil) {
                objc_setAssociatedObject(self, #function, self.safeValueForKey(AssociatedKeys.kKeyScrollViewVerticalIndicator), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN);
            }
            return objc_getAssociatedObject(self, #function) as! UIView
        }
    }
    
    /// The horizontal scroll indicator view.
    public var horizontalScroller: UIView {
        get {
            if (objc_getAssociatedObject(self, #function) == nil) {
                objc_setAssociatedObject(self, #function, self.safeValueForKey(AssociatedKeys.kKeyScrollViewHorizontalIndicator), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN);
            }
            return objc_getAssociatedObject(self, #function) as! UIView
        }
    }
    
    fileprivate func safeValueForKey(_ key: String) -> AnyObject{
        let instanceVariable: Ivar = class_getInstanceVariable(type(of: self), key.cString(using: String.Encoding.utf8)!)!
        return object_getIvar(self, instanceVariable) as AnyObject;
    }
    
    
    /**
     Sets the content offset to the top.
     
     - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
     */
    public func scrollToTopAnimated(_ animated: Bool) {
        if !self.isAtTop {
            let bottomOffset = CGPoint.zero;
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    /**
     Sets the content offset to the bottom.
     
     - parameter animated: animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
     */
    public func scrollToBottomAnimated(_ animated: Bool) {
        if self.canScrollToBottom && !self.isAtBottom {
            let bottomOffset = CGPoint(x: 0.0, y: self.contentSize.height - self.bounds.size.height)
            self.setContentOffset(bottomOffset, animated: animated)
        }
    }
    
    /**
     Stops scrolling, if it was scrolling.
     */
    public func stopScrolling() {
        guard self.isDragging else {
            return
        }
        var offset = self.contentOffset
        offset.y -= 1.0
        self.setContentOffset(offset, animated: false)
        
        offset.y += 1.0
        self.setContentOffset(offset, animated: false)
    }
}


public extension UIScrollView {
    
    public convenience init(frame: CGRect, contentSize: CGSize, clipsToBounds: Bool, pagingEnabled: Bool, showScrollIndicators: Bool, delegate: UIScrollViewDelegate?) {
        self.init(frame: frame)
        self.delegate = delegate
        self.isPagingEnabled = pagingEnabled
        self.clipsToBounds = clipsToBounds
        self.showsVerticalScrollIndicator = showScrollIndicators
        self.showsHorizontalScrollIndicator = showScrollIndicators
        self.contentSize = contentSize
    }
    
    public var isOverflowVertical: Bool {
        return self.contentSize.height > bounds.height && bounds.height > 0
    }
    
    public func isReachedBottom(withTolerance tolerance: CGFloat = 0) -> Bool {
        guard self.isOverflowVertical else { return false }
        let contentOffsetBottom = self.contentOffset.y + bounds.height
        return contentOffsetBottom >= self.contentSize.height - tolerance
    }
    
    public func scrollToBottom(animated: Bool) {
        guard self.isOverflowVertical else { return }
        let targetY = self.contentSize.height + self.contentInset.bottom - bounds.height
        let targetOffset = CGPoint(x: 0, y: targetY)
        self.setContentOffset(targetOffset, animated: true)
    }
    
    public func scrollToTop(animated: Bool = true) {
        let inset = contentInset
        setContentOffset(CGPoint(x: -inset.left, y: -inset.top), animated: animated)
    }
    
}
