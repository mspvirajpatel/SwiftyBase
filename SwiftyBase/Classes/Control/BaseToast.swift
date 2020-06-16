//
//  BaseToast.swift
//  Pods
//
//  Created by MacMini-2 on 12/09/17.
//
//

import Foundation
import UIKit

/*
 *  Infix overload method
 */
func / (lhs: CGFloat, rhs: Int) -> CGFloat {
    return lhs / CGFloat(rhs)
}

/*
 *  Toast Config
 */
let BaseToastDefaultDuration = 2.0
let BaseToastFadeDuration = 0.2
let BaseToastHorizontalMargin: CGFloat = 10.0
let BaseToastVerticalMargin: CGFloat = 10.0

let BaseToastPositionDefault = "bottom"
let BaseToastPositionTop = "top"
let BaseToastPositionCenter = "center"

// activity
let BaseToastActivityWidth: CGFloat = 100.0
let BaseToastActivityHeight: CGFloat = 100.0
let BaseToastActivityPositionDefault = "center"

// image size
let BaseToastImageViewWidth: CGFloat = 80.0
let BaseToastImageViewHeight: CGFloat = 80.0

// label setting
let BaseToastMaxWidth: CGFloat = 0.8; // 80% of parent view width
let BaseToastMaxHeight: CGFloat = 0.8
let BaseToastFontSize: CGFloat = 16.0
let BaseToastMaxTitleLines = 0
let BaseToastMaxMessageLines = 0

// shadow appearance
let BaseToastShadowOpacity: CGFloat = 0.8
let BaseToastShadowRadius: CGFloat = 6.0
let BaseToastShadowOffset: CGSize = CGSize(width: CGFloat(4.0), height: CGFloat(4.0))

let BaseToastOpacity: CGFloat = 0.9
let BaseToastCornerRadius: CGFloat = 10.0

var BaseToastActivityView: UnsafePointer<UIView>? = nil
var BaseToastTimer: UnsafePointer<Timer>? = nil
var BaseToastView: UnsafePointer<UIView>? = nil
var BaseToastThemeColor: UnsafePointer<UIColor>? = nil
var BaseToastTitleFontName: UnsafePointer<String>? = nil
var BaseToastFontName: UnsafePointer<String>? = nil
var BaseToastFontColor: UnsafePointer<UIColor>? = nil

/*
 *  Custom Config
 */
let BaseToastHidesOnTap = true
let BaseToastDisplayShadow = true

//BaseToast (UIView + Toast using Swift)
public extension UIView {

    /*
     *  public methods
     */
    class func setToastThemeColor(color: UIColor) {
        objc_setAssociatedObject(self, &BaseToastThemeColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    class func toastThemeColor() -> UIColor {
        var color = objc_getAssociatedObject(self, &BaseToastThemeColor) as! UIColor?
        if color == nil {
            color = UIColor.black
            UIView.setToastThemeColor(color: color!)
        }
        return color!
    }

    class func setToastTitleFontName(fontName: String) {
        objc_setAssociatedObject(self, &BaseToastTitleFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    class func toastTitleFontName() -> String {
        var name = objc_getAssociatedObject(self, &BaseToastTitleFontName) as! String?
        if name == nil {
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.setToastTitleFontName(fontName: name!)
        }

        return name!
    }

    class func setToastFontName(fontName: String) {
        objc_setAssociatedObject(self, &BaseToastFontName, fontName, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    class func toastFontName() -> String {
        var name = objc_getAssociatedObject(self, &BaseToastFontName) as! String?
        if name == nil {
            let font = UIFont.systemFont(ofSize: 12.0)
            name = font.fontName
            UIView.setToastFontName(fontName: name!)
        }

        return name!
    }

    class func setToastFontColor(color: UIColor) {
        objc_setAssociatedObject(self, &BaseToastFontColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }

    class func toastFontColor() -> UIColor {
        var color = objc_getAssociatedObject(self, &BaseToastFontColor) as! UIColor?
        if color == nil {
            color = UIColor.white
            UIView.setToastFontColor(color: color!)
        }

        return color!
    }

    func makeToast(message msg: String) {
        makeToast(message: msg, duration: BaseToastDefaultDuration, position: BaseToastPositionDefault as AnyObject)
    }

    func makeToast(message msg: String, duration: Double, position: AnyObject) {
        let toast = self.viewForMessage(msg, title: nil, image: nil)
        showToast(toast: toast!, duration: duration, position: position)
    }

    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String) {
        let toast = self.viewForMessage(msg, title: title, image: nil)
        showToast(toast: toast!, duration: duration, position: position)
    }

    func makeToast(message msg: String, duration: Double, position: AnyObject, image: UIImage) {
        let toast = self.viewForMessage(msg, title: nil, image: image)
        showToast(toast: toast!, duration: duration, position: position)
    }

    func makeToast(message msg: String, duration: Double, position: AnyObject, title: String, image: UIImage) {
        let toast = self.viewForMessage(msg, title: title, image: image)
        showToast(toast: toast!, duration: duration, position: position)
    }

    func showToast(toast: UIView) {
        showToast(toast: toast, duration: BaseToastDefaultDuration, position: BaseToastPositionDefault as AnyObject)
    }

    fileprivate func showToast(toast: UIView, duration: Double, position: AnyObject) {
        let existToast = objc_getAssociatedObject(self, &BaseToastView) as! UIView?
        if existToast != nil {
            if let timer: Timer = objc_getAssociatedObject(existToast as Any, &BaseToastTimer) as? Timer {
                timer.invalidate()
            }
            hideToast(toast: existToast!, force: false)
            print("hide exist!")
        }

        toast.center = centerPointForPosition(position, toast: toast)
        toast.alpha = 0.0

        if BaseToastHidesOnTap {
            let tapRecognizer = UITapGestureRecognizer(target: toast, action: #selector(UIView.handleToastTapped(_:)))
            toast.addGestureRecognizer(tapRecognizer)
            toast.isUserInteractionEnabled = true
            toast.isExclusiveTouch = true
        }

        addSubview(toast)
        objc_setAssociatedObject(self, &BaseToastView, toast, .OBJC_ASSOCIATION_RETAIN)

        UIView.animate(withDuration: BaseToastFadeDuration,
                       delay: 0.0, options: ([.curveEaseOut, .allowUserInteraction]),
                       animations: {
                           toast.alpha = 1.0
                       },
                       completion: { (finished: Bool) in
                           let timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(UIView.toastTimerDidFinish(_:)), userInfo: toast, repeats: false)
                           objc_setAssociatedObject(toast, &BaseToastTimer, timer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                       })
    }

    func makeToastActivity() {
        makeToastActivity(position: BaseToastActivityPositionDefault as AnyObject)
    }

    func makeToastActivity(message msg: String) {
        makeToastActivity(position: BaseToastActivityPositionDefault as AnyObject, message: msg)
    }

    fileprivate func makeToastActivity(position pos: AnyObject, message msg: String = "") {
        let existingActivityView: UIView? = objc_getAssociatedObject(self, &BaseToastActivityView) as? UIView
        if existingActivityView != nil { return }

        let activityView = UIView(frame: CGRect(x: 0, y: 0, width: BaseToastActivityWidth, height: BaseToastActivityHeight))
        activityView.layer.cornerRadius = BaseToastCornerRadius

        activityView.center = self.centerPointForPosition(pos, toast: activityView)
        activityView.backgroundColor = UIView.toastThemeColor().withAlphaComponent(BaseToastOpacity)
        activityView.alpha = 0.0
        activityView.autoresizingMask = ([.flexibleLeftMargin, .flexibleTopMargin, .flexibleRightMargin, .flexibleBottomMargin])

        if BaseToastDisplayShadow {
            activityView.layer.shadowColor = UIView.toastThemeColor().cgColor
            activityView.layer.shadowOpacity = Float(BaseToastShadowOpacity)
            activityView.layer.shadowRadius = BaseToastShadowRadius
            activityView.layer.shadowOffset = BaseToastShadowOffset
        }

        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.center = CGPoint(x: activityView.bounds.size.width / 2, y: activityView.bounds.size.height / 2)
        activityView.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()

        if (!msg.isEmpty) {
            activityIndicatorView.frame.origin.y -= 10
            let activityMessageLabel = UILabel(frame: CGRect(x: activityView.bounds.origin.x, y: (activityIndicatorView.frame.origin.y + activityIndicatorView.frame.size.height + 10), width: activityView.bounds.size.width, height: 20))
            activityMessageLabel.textColor = UIView.toastFontColor()
            activityMessageLabel.font = (msg.count <= 10) ? UIFont(name: UIView.toastFontName(), size: 16) : UIFont(name: UIView.toastFontName(), size: 13)
            activityMessageLabel.textAlignment = .center
            activityMessageLabel.text = msg
            activityView.addSubview(activityMessageLabel)
        }

        addSubview(activityView)

        // associate activity view with self
        objc_setAssociatedObject(self, &BaseToastActivityView, activityView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        UIView.animate(withDuration: BaseToastFadeDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                           activityView.alpha = 1.0
                       },
                       completion: nil)
    }

    func hideToastActivity() {
        let existingActivityView = objc_getAssociatedObject(self, &BaseToastActivityView) as! UIView?
        if existingActivityView == nil { return }
        UIView.animate(withDuration: BaseToastFadeDuration,
                       delay: 0.0,
                       options: UIView.AnimationOptions.curveEaseOut,
                       animations: {
                           existingActivityView!.alpha = 0.0
                       },
                       completion: { (finished: Bool) in
                           existingActivityView!.removeFromSuperview()
                           objc_setAssociatedObject(self, &BaseToastActivityView, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                       })
    }

    /*
     *  private methods (helper)
     */
    func hideToast(toast: UIView) {
        hideToast(toast: toast, force: false)
    }

    func hideToast(toast: UIView, force: Bool) {
        let completeClosure = { (finish: Bool) -> () in
            toast.removeFromSuperview()
            objc_setAssociatedObject(self, &BaseToastTimer, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        if force {
            completeClosure(true)
        } else {
            UIView.animate(withDuration: BaseToastFadeDuration,
                           delay: 0.0,
                           options: ([.curveEaseIn, .beginFromCurrentState]),
                           animations: {
                               toast.alpha = 0.0
                           },
                           completion: completeClosure)
        }
    }

    @objc func toastTimerDidFinish(_ timer: Timer) {
        hideToast(toast: timer.userInfo as! UIView)
    }

    @objc func handleToastTapped(_ recognizer: UITapGestureRecognizer) {
        let timer = objc_getAssociatedObject(self, &BaseToastTimer) as! Timer
        timer.invalidate()

        hideToast(toast: recognizer.view!)
    }

    fileprivate func centerPointForPosition(_ position: AnyObject, toast: UIView) -> CGPoint {
        if position is String {
            let toastSize = toast.bounds.size
            let viewSize = self.bounds.size
            if position.lowercased == BaseToastPositionTop {
                return CGPoint(x: viewSize.width / 2, y: toastSize.height / 2 + BaseToastVerticalMargin)
            } else if position.lowercased == BaseToastPositionDefault {
                return CGPoint(x: viewSize.width / 2, y: viewSize.height - toastSize.height / 2 - BaseToastVerticalMargin)
            } else if position.lowercased == BaseToastPositionCenter {
                return CGPoint(x: viewSize.width / 2, y: viewSize.height / 2)
            }
        } else if position is NSValue {
            return position.cgPointValue
        }

        print("[Toast-Swift]: Warning! Invalid position for toast.")
        return self.centerPointForPosition(BaseToastPositionDefault as AnyObject, toast: toast)
    }

    fileprivate func viewForMessage(_ msg: String?, title: String?, image: UIImage?) -> UIView? {
        if msg == nil && title == nil && image == nil { return nil }

        var msgLabel: UILabel?
        var titleLabel: UILabel?
        var imageView: UIImageView?

        let wrapperView = UIView()
        wrapperView.autoresizingMask = ([.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin])
        wrapperView.layer.cornerRadius = BaseToastCornerRadius
        wrapperView.backgroundColor = UIView.toastThemeColor().withAlphaComponent(BaseToastOpacity)

        if BaseToastDisplayShadow {
            wrapperView.layer.shadowColor = UIView.toastThemeColor().cgColor
            wrapperView.layer.shadowOpacity = Float(BaseToastShadowOpacity)
            wrapperView.layer.shadowRadius = BaseToastShadowRadius
            wrapperView.layer.shadowOffset = BaseToastShadowOffset
        }

        if image != nil {
            imageView = UIImageView(image: image)
            imageView!.contentMode = .scaleAspectFit
            imageView!.frame = CGRect(x: BaseToastHorizontalMargin, y: BaseToastVerticalMargin, width: CGFloat(BaseToastImageViewWidth), height: CGFloat(BaseToastImageViewHeight))
        }

        var imageWidth: CGFloat, imageHeight: CGFloat, imageLeft: CGFloat
        if imageView != nil {
            imageWidth = imageView!.bounds.size.width
            imageHeight = imageView!.bounds.size.height
            imageLeft = BaseToastHorizontalMargin
        } else {
            imageWidth = 0.0; imageHeight = 0.0; imageLeft = 0.0
        }

        if title != nil {
            titleLabel = UILabel()
            titleLabel!.numberOfLines = BaseToastMaxTitleLines
            titleLabel!.font = UIFont(name: UIView.toastFontName(), size: BaseToastFontSize)
            titleLabel!.textAlignment = .center
            titleLabel!.lineBreakMode = .byWordWrapping
            titleLabel!.textColor = UIView.toastFontColor()
            titleLabel!.backgroundColor = UIColor.clear
            titleLabel!.alpha = 1.0
            titleLabel!.text = title

            // size the title label according to the length of the text
            let maxSizeTitle = CGSize(width: (self.bounds.size.width * BaseToastMaxWidth) - imageWidth, height: self.bounds.size.height * BaseToastMaxHeight)
            let expectedHeight = title!.stringHeightWithFontSize(BaseToastFontSize, width: maxSizeTitle.width)
            titleLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeTitle.width, height: expectedHeight)
        }

        if msg != nil {
            msgLabel = UILabel()
            msgLabel!.numberOfLines = BaseToastMaxMessageLines
            msgLabel!.font = UIFont(name: UIView.toastFontName(), size: BaseToastFontSize)
            msgLabel!.lineBreakMode = .byWordWrapping
            msgLabel!.textAlignment = .center
            msgLabel!.textColor = UIView.toastFontColor()
            msgLabel!.backgroundColor = UIColor.clear
            msgLabel!.alpha = 1.0
            msgLabel!.text = msg

            let maxSizeMessage = CGSize(width: (self.bounds.size.width * BaseToastMaxWidth) - imageWidth, height: self.bounds.size.height * BaseToastMaxHeight)
            let expectedHeight = msg!.stringHeightWithFontSize(BaseToastFontSize, width: maxSizeMessage.width)
            msgLabel!.frame = CGRect(x: 0.0, y: 0.0, width: maxSizeMessage.width, height: expectedHeight)
        }

        var titleWidth: CGFloat, titleHeight: CGFloat, titleTop: CGFloat, titleLeft: CGFloat
        if titleLabel != nil {
            titleWidth = titleLabel!.bounds.size.width
            titleHeight = titleLabel!.bounds.size.height
            titleTop = BaseToastVerticalMargin
            titleLeft = imageLeft + imageWidth + BaseToastHorizontalMargin
        } else {
            titleWidth = 0.0; titleHeight = 0.0; titleTop = 0.0; titleLeft = 0.0
        }

        var msgWidth: CGFloat, msgHeight: CGFloat, msgTop: CGFloat, msgLeft: CGFloat
        if msgLabel != nil {
            msgWidth = msgLabel!.bounds.size.width
            msgHeight = msgLabel!.bounds.size.height
            msgTop = titleTop + titleHeight + BaseToastVerticalMargin
            msgLeft = imageLeft + imageWidth + BaseToastHorizontalMargin
        } else {
            msgWidth = 0.0; msgHeight = 0.0; msgTop = 0.0; msgLeft = 0.0
        }

        let largerWidth = max(titleWidth, msgWidth)
        let largerLeft = max(titleLeft, msgLeft)

        // set wrapper view's frame
        let wrapperWidth = max(imageWidth + BaseToastHorizontalMargin * 2, largerLeft + largerWidth + BaseToastHorizontalMargin)
        let wrapperHeight = max(msgTop + msgHeight + BaseToastVerticalMargin, imageHeight + BaseToastVerticalMargin * 2)
        wrapperView.frame = CGRect(x: 0.0, y: 0.0, width: wrapperWidth, height: wrapperHeight)

        // add subviews
        if titleLabel != nil {
            titleLabel!.frame = CGRect(x: titleLeft, y: titleTop, width: titleWidth, height: titleHeight)
            wrapperView.addSubview(titleLabel!)
        }
        if msgLabel != nil {
            msgLabel!.frame = CGRect(x: msgLeft, y: msgTop, width: msgWidth, height: msgHeight)
            wrapperView.addSubview(msgLabel!)
        }
        if imageView != nil {
            wrapperView.addSubview(imageView!)
        }

        return wrapperView
    }

}

