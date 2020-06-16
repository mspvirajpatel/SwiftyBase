//
//  BaseTextView.swift
//  Pods
//
//  Created by MacMini-2 on 07/09/17.
//
//

import Foundation
import UIKit

/**
 This is Base Class of TextView.
 
 - placeholder: Placeholder String of uitextview.
 - placeHolderLabel: Object of PlaceHolder Label.
 - borderView: Its show the Border on uitextview
 - leftArrowButton: Object of left Arrao button when keyboard will show
 - rightArrowButton: Object of Right Arraw button when keyboard will show
 - isMultiLinesSupported: Boolian value for set the Multiline support in TextView
 */
open class BaseTextView: UITextView, UITextViewDelegate, UIScrollViewDelegate {

    // MARK: - Attributes -
    open var placeholder: String!
    open var placeHolderLabel: UILabel!
    open var borderView: UIView!

    open var isMultiLinesSupported: Bool = false

    // MARK: - Lifecycle -
    public init(iSuperView: UIView?) {
        super.init(frame: CGRect.zero, textContainer: nil)

        self.setCommonProperties()
        self.setlayout()

        if(iSuperView != nil) {
            iSuperView!.addSubview(self)
            self.delegate = self
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

    }
    /**
     Here we override the Draw rect method of UITextView for set the Placeholder Label in TextView.
     */
    override open func draw(_ rect: CGRect) {
        superview?.draw(rect)

        if(self.placeholder.count > 0) {

            if(placeHolderLabel == nil) {

                placeHolderLabel = UILabel(frame: CGRect(x: 10, y: 6, width: self.bounds.size.width - 16, height: 0))

                placeHolderLabel.lineBreakMode = .byWordWrapping
                placeHolderLabel.numberOfLines = 0

                placeHolderLabel.font = self.font
                placeHolderLabel.backgroundColor = UIColor.clear

                placeHolderLabel.textColor = AppColor.textFieldPlaceholder.withAlpha(0.45)
                placeHolderLabel.alpha = 0.0

                placeHolderLabel.tag = 999
                self.addSubview(placeHolderLabel)
            }

            placeHolderLabel.text = self.placeholder
            placeHolderLabel.sizeToFit()

            self.sendSubviewToBack(placeHolderLabel)

        }

        if(self.text!.count == 0 && self.placeholder.count > 0) {
            self.viewWithTag(999)?.alpha = 1
        }

    }

    override open var text: String? {
        didSet {
            self.textViewDidChange(self)
        }
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit {

        //  baseLayout = nil
        placeholder = nil

        placeHolderLabel = nil
        borderView = nil

    }

    // MARK: - Layout -
    /// Its will set the commond properties of TextView  like background color,EdgeInsets of Text,Key type,font etc...
    func setCommonProperties() {

        self.translatesAutoresizingMaskIntoConstraints = false
        self.textContainerInset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        self.autocapitalizationType = .sentences
        self.autocorrectionType = .default
        self.keyboardAppearance = .dark
        self.textColor = AppColor.textFieldText.value
        self.backgroundColor = AppColor.textFieldBG.value
        self.font = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h3) : .standard(.h4)).instance
        self.setBorder(AppColor.textFieldBorder.value, width: 1.5, radius: ControlConstant.borderRadius)
    }

    func setlayout() {


    }

    // MARK: - Public Interface -
    /// Method for show the error on textview
    open func setErrorBorder() {
        self.setBorder(AppColor.textFieldErrorBorder.withAlpha(0.45), width: ControlConstant.txtBorderWidth, radius: ControlConstant.txtBorderRadius)
    }

    /// method for reset the scrollview content off when keyboard close or done button clicked.
    open func resetScrollView() {

        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self)

            if(scrollView != nil) {

                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                    if self == nil {
                        return
                    }

                    scrollView?.setContentOffset(CGPoint.zero, animated: true)
                    scrollView = nil
                }
            }
        }
    }

    /// Method for show/Hide the Toolbar with done,Up and Down arrow button on keyboard.


    /// Method for show/Hide the Toolbar with done,Up and Down arrow button on keyboard.

    open func setHideBottomBorder(_ hidden: Bool) {
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.borderView.isHidden = hidden
        }
    }

    // MARK: - User Interaction -



    // MARK: - Internal Helpers -




    func setScrollViewContentOffsetForView(_ view: UIView) {

        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }
            var viewRect: CGRect

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self)

            if(scrollView != nil) {
                viewRect = view.frame
                let screenRect: CGRect = UIScreen.main.bounds
                let viewableScreenHeight: CGFloat = screenRect.size.height - 308
                // When the user is on a form field, get the current form field y position to where the scroll view should move to
                let currentFormFieldYPosition: CGFloat = viewRect.origin.y
                // I want the current form field y position to be 100dp from the keyboard y position.
                // 50dp for the current form field to be visible and another 50dp for the next form field so users can see it.
                let leftoverTopHeight: CGFloat = viewableScreenHeight - 150
                // If the current form field y position is greater than the left over top height, that means that the current form field is hidden
                // We make the calculations and then move the scroll view to the right position
                if currentFormFieldYPosition > leftoverTopHeight {
                    AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                        if self == nil {
                            return
                        }
                        let movedScreenPosition: CGFloat = currentFormFieldYPosition - leftoverTopHeight

                        scrollView?.setContentOffset(CGPoint(x: 0.0, y: movedScreenPosition), animated: true)

                        scrollView = nil
                    }
                }
                else {
                    self?.resetScrollView()
                }
            }
        }

        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self!)

            if(scrollView != nil) {

                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                    if self == nil {
                        return
                    }
                    scrollView?.setContentOffset(CGPoint(x: 0.0, y: view.frame.origin.y), animated: true)
                    scrollView = nil
                }
            }
        }
    }

    func getScrollViewFromView(_ view: UIView?) -> UIScrollView? {

        var scrollView: UIScrollView? = nil
        var view: UIView? = view!.superview!

        while (view != nil) {

            if(view!.isKind(of: UIScrollView.self)) {
                scrollView = view as? UIScrollView
                break
            }

            if(view!.superview != nil) {
                view = view!.superview!
            }
            else {
                view = nil
            }
        }
        return scrollView
    }

    func setResponderToTextControl(_ iDirectionType: ResponderDirectionType) {

        if(self.superview != nil && self.isEditable) {

            AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

                if self == nil {
                    return
                }

                var subViewArray: Array! = (self!.superview?.subviews)!
                let subViewArrayCount: Int = subViewArray!.count

                var isNextTextControlAvailable: Bool = false
                let currentTextFieldIndex: Int = subViewArray.firstIndex(of: self!)!

                var textField: UITextField?
                var textView: UITextView?

                var view: UIView?

                let operatorSign = (iDirectionType == .leftResponderDirectionType) ? -1 : 1
                var i = currentTextFieldIndex + operatorSign

                while(i >= 0 && i < subViewArrayCount) {

                    view = subViewArray[i]
                    isNextTextControlAvailable = view!.isKind(of: UITextField.self) || view!.isKind(of: UITextView.self)

                    if(isNextTextControlAvailable) {

                        if(view!.isKind(of: UITextField.self)) {

                            textField = view as? UITextField
                            if(textField!.isEnabled && textField!.delegate != nil) {

                                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                                    if self == nil {
                                        return
                                    }
                                    textField?.becomeFirstResponder()
                                }

                                break
                            } else {
                                isNextTextControlAvailable = false
                            }

                        } else if(view!.isKind(of: UITextView.self)) {

                            textView = view as? UITextView
                            if(textView!.isEditable && textView!.delegate != nil) {

                                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                                    if self == nil {
                                        return
                                    }
                                    textView?.becomeFirstResponder()
                                }
                                break
                            } else {
                                isNextTextControlAvailable = false
                            }
                        }

                    }

                    i = i + operatorSign
                }

                if(isNextTextControlAvailable && view != nil) {
                    self!.setScrollViewContentOffsetForView(view!)
                }
                subViewArray = nil
                textView = nil
                textField = nil
            }
        }
    }

    // MARK: - UITextView Delegate Methods -

    public func textViewDidChange(_ textView: UITextView) {
        if(self.placeholder.count == 0) {
            return
        }

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            UIView.animate(withDuration: 0.25, animations: { [weak self] in

                if self == nil {
                    return
                }

                if(!self!.hasText) {
                    self!.viewWithTag(999)?.alpha = 1.0

                } else {
                    self!.viewWithTag(999)?.alpha = 0.0
                }
            })
        }
    }

    public func textViewDidBeginEditing(_ textView: UITextView) {

        self.setScrollViewContentOffsetForView(self)
        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self!)

            if(scrollView != nil) {

                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                    if self == nil {
                        return
                    }
                    scrollView?.isScrollEnabled = false
                    scrollView = nil
                }
            }
        }
    }

    public func textViewDidEndEditing(_ textView: UITextView) {

        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self!)

            if(scrollView != nil) {

                AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
                    if self == nil {
                        return
                    }
                    scrollView?.isScrollEnabled = true
                    scrollView = nil
                }
            }
        }
    }

    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

        if(text == "\n" && !self.isMultiLinesSupported) {

            textView.resignFirstResponder()
            self.resetScrollView()

            return false
        }

        return true
    }


    // MARK: - UIScrollView Delegate Methods -

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.layoutSubviews()
    }

}
