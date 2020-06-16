//
//  BaseTextField.swift
//  Pods
//
//  Created by MacMini-2 on 06/09/17.
//
//

import Foundation
import UIKit

/**
 Respondent Direction Type Enum
 */
public enum ResponderDirectionType: Int {

    case leftResponderDirectionType = 1
    case rightResponderDirectionType = 2
}

/**
 Base TextField Type
 
 - primary: Default Type
 - noAutoScroll: For Not want Auto Scroll when keyboard show
 - showPassword: For Password Textfiedl with show/hide button
 - withoutClear: For TextField Without clear button
 
 */
public enum BaseTextFieldType: Int {

    case primary = 0 // Default Type
    case noAutoScroll // For Not want Auto Scroll when keyboard show
    case showPassword // For Password Textfiedl with show/hide button
    case withoutClear // For TextField Without clear button
    case none
    init(named baseButtonType: String) {
        switch baseButtonType
        {
        case "primary": self = .primary
            break
        case "noAutoScroll": self = .noAutoScroll
            break
        case "showPassword": self = .showPassword
            break
        case "withoutClear": self = .withoutClear
            break
        default: self = .none
            break
        }
    }
}

/**
 Class for Base TextField. Its public variable as per under.
 
 - inputAccessory: variable for show input accessory view on keyword while editing like done,next and preview button
 - baseLayout: Object for layout class
 - charaterLimit: for define maximum character limit on textfield
 -baseTextFieldType: TextField Type.
 
 */
private var _showImage: UIImage! = UIImage.init(named: "ShowPassword")
private var _hideImage: UIImage! = UIImage.init(named: "HidePassword")

open class BaseTextField: UITextField, UITextFieldDelegate {

    // MARK: - Attributes -

    open var inputAccessory: UIView!

    open var charaterLimit: Int = 9999
    open var type: BaseTextFieldType = BaseTextFieldType.primary

    public var btnShowPassword: UIButton!

    @IBInspectable open var TextFieldType: String? {
        willSet {
            type = BaseTextFieldType(named: newValue ?? "primary")
            self.setCommonProperties()
            self.setlayout()
        }
    }

    //if set . showPassword Must be Set This Variable
    @IBInspectable open var setShowPasswordImage: UIImage {
        get {
            return _showImage
        }
        set {
            _showImage = newValue

            btnShowPassword.setImage(_showImage, for: .normal)

        }
    }

    @IBInspectable open var setHidePasswordImage: UIImage {
        get {
            return _hideImage
        }
        set {
            _hideImage = newValue
            btnShowPassword.setImage(_hideImage, for: .selected)
        }
    }

    // MARK: - Lifecycle -

    public init(iSuperView: UIView?, TextFieldType baseType: BaseTextFieldType)
    {
        super.init(frame: CGRect.zero)

        type = baseType

        self.setCommonProperties()
        self.setlayout()

        if iSuperView != nil
            {
            iSuperView?.addSubview(self)
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

    }

    /**
     override the Draw placeholder method of UITextField class for set the placeholder as per our requirement like put padding at left side of placeholder.
     */
    override open func drawPlaceholder(in rect: CGRect)
    {
        if(self.placeholder!.responds(to: #selector(NSString.draw(at: withAttributes:))))
        {

            var attributes: [NSAttributedString.Key: Any]! = [NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): AppColor.textFieldPlaceholder.withAlpha(0.45),
                                                              NSAttributedString.Key.font: self.font!]

            var boundingRect: CGRect! = self.placeholder!.boundingRect(with: rect.size, options: NSStringDrawingOptions(rawValue: 0), attributes: attributes, context: nil)

            switch type
            {
            case .withoutClear:
                self.placeholder!.draw(at: CGPoint(x: (rect.size.width / 2) - boundingRect.size.width / 2, y: (rect.size.height / 2) - boundingRect.size.height / 2), withAttributes: attributes)
                break
            default:
                self.placeholder!.draw(at: CGPoint(x: 0, y: (rect.size.height / 2) - boundingRect.size.height / 2), withAttributes: attributes)
                break
            }
            attributes.removeAll()
            attributes = nil
            boundingRect = nil
        }
    }

    /**
     Override the TextRect Method of UITextField class for set the Text in controlr and put left and right padding.
     
     */
    override open func textRect(forBounds bounds: CGRect) -> CGRect {

        var customBounds: CGRect!

        switch type {
        case .showPassword:

            customBounds = CGRect(x: bounds.origin.x + ControlConstant.textLeftPadding, y: bounds.origin.y, width: bounds.size.width - 4.8 * ControlConstant.textLeftPadding, height: bounds.size.height)
            break

        case .withoutClear:

            customBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            break

        default:

            customBounds = CGRect(x: bounds.origin.x + ControlConstant.textLeftPadding, y: bounds.origin.y, width: bounds.size.width - 3.8 * ControlConstant.textLeftPadding, height: bounds.size.height)
            break
        }

        return customBounds
    }

    /**
     Override the editingRect Method of UITextField class while editing is on in textfield for set the Text in controlr and put left and right padding.
     
     */
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {

        var customBounds: CGRect!

        switch type {
        case .showPassword:

            customBounds = CGRect(x: bounds.origin.x + ControlConstant.textLeftPadding, y: bounds.origin.y, width: bounds.size.width - 4.8 * ControlConstant.textLeftPadding, height: bounds.size.height)
            break

        case .withoutClear:

            customBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: bounds.size.width, height: bounds.size.height)
            break

        default:

            customBounds = CGRect(x: bounds.origin.x + ControlConstant.textLeftPadding, y: bounds.origin.y, width: bounds.size.width - 3.8 * ControlConstant.textLeftPadding, height: bounds.size.height)
            break
        }
        return customBounds!
    }

    override open var text: String? {
        didSet {

        }
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit {

        inputAccessory = nil

    }

    // MARK: - Layout -
    /**
     This method set the commond propary of textfield as per Type
     */
    func setCommonProperties() {

        switch type
        {
        case .noAutoScroll:

            self.clearButtonMode = .whileEditing
            self.textAlignment = .left
            break

        case .primary:

            self.clearButtonMode = .whileEditing
            self.returnKeyType = .default
            self.delegate = self
            self.textAlignment = .left
            break

        case .showPassword:

            self.isSecureTextEntry = true
            self.returnKeyType = .default
            self.clearButtonMode = .never
            self.delegate = self
            self.textAlignment = .left
            break

        case .withoutClear:

            self.clearButtonMode = .never
            self.delegate = self
            self.textAlignment = .center
            break

        default:

            break
        }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.keyboardAppearance = .dark

        self.autocapitalizationType = .none
        self.autocorrectionType = .default


        self.backgroundColor = AppColor.textFieldBG.value
        self.textColor = AppColor.textFieldText.value
        self.font = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h3) : .standard(.h4)).instance
        self.setBorder(AppColor.textFieldBorder.value,
                       width: 1.5,
                       radius: ControlConstant.borderRadius)
    }

    /**
     This method set the layout of textfield as per type.
     */
    func setlayout() {

        var baseLayout: AppBaseLayout!
        baseLayout = AppBaseLayout()

        baseLayout.viewDictionary = ["textField": self]

        let textFieldHeight: CGFloat = currentDevice.isIpad ? 50.0 : 35.0
        let textFieldWidth: CGFloat = currentDevice.isIpad ? 40.0 : 50.0

        baseLayout.metrics = ["textFieldHeight": textFieldHeight, "textFieldWidth": textFieldWidth]

        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[textField(textFieldHeight)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

        self.addConstraints(baseLayout.control_V)

        switch type
        {
        case .showPassword:

            btnShowPassword = UIButton(type: UIButton.ButtonType.custom)
            btnShowPassword.translatesAutoresizingMaskIntoConstraints = false
            btnShowPassword.backgroundColor = self.backgroundColor
            if _showImage != nil {
                btnShowPassword .setImage(_showImage, for: UIControl.State.normal)
            }
            if _hideImage != nil {
                btnShowPassword .setImage(_hideImage, for: UIControl.State.selected)
            }

            btnShowPassword .addTarget(self, action: #selector(self.btnShowPassword(sender:)), for: .touchUpInside)
            btnShowPassword .isSelected = true
            self.addSubview(btnShowPassword)

            baseLayout.viewDictionary = ["btnShowPassword": btnShowPassword]
            baseLayout.metrics = ["buttonHeight": textFieldHeight]
            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnShowPassword]|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            baseLayout.position_Right = NSLayoutConstraint(item: btnShowPassword, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)
            baseLayout.size_Width = NSLayoutConstraint(item: btnShowPassword, attribute: .width, relatedBy: .equal, toItem: btnShowPassword, attribute: .height, multiplier: 1.0, constant: 0.0)

            self.addConstraint(baseLayout.size_Width)
            self.addConstraints(baseLayout.control_V)
            self.addConstraint(baseLayout.position_Right)
            break

        case .withoutClear:

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[textField(textFieldWidth)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)
            break

        default:
            break
        }

        baseLayout.releaseObject()
        baseLayout = nil
    }


    // MARK: - Public Interface -
    /**
     Method for show the error border on textfield when user input invalide content.
     */
    open func setErrorBorder() {
        self.setBorder(AppColor.textFieldErrorBorder.withAlpha(0.6), width: ControlConstant.txtBorderWidth, radius: ControlConstant.txtBorderRadius)
    }

    /**
     Method for remove the error border on textfield when user input valid content.
     */
    open func clearErrorBorder() {
        self.setBorder(AppColor.textFieldErrorBorder.withAlpha(0.6), width: ControlConstant.txtBorderWidth, radius: ControlConstant.txtBorderRadius)
    }

    /**
     Method for reset the scrollview contentoff set zero when user fill whole form or stop the editing.
     */
    open func resetScrollView() {

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

                    scrollView?.setContentOffset(CGPoint.zero, animated: true)

                    scrollView = nil
                }
            }
        }
    }


    // MARK: - Internal Helpers -
    @objc func btnShowPassword(sender: UIButton) -> Void
    {
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.text = self.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        var button: UIButton! = sender
        button.isSelected = self.isSecureTextEntry
        button = nil
    }


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

            } else {
                view = nil
            }
        }
        return scrollView
    }

    /**
     Its used for check the Next and previous control is available or not in Form and Navigate to next and previeous controll as per user click on button.
     
     - iDirectionType: Direction for navigation to up or down
     
     */
    func setResponderToTextControl(_ iDirectionType: ResponderDirectionType) {

        if(self.superview != nil && self.isEnabled) {

            AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

                if self == nil {
                    return
                }

                let subViewArray: Array! = (self!.superview?.subviews)!
                let subViewArrayCount: Int = subViewArray.count

                var isNextTextControlAvailable: Bool = false
                let currentTextFieldIndex: Int = subViewArray.firstIndex(of: self!)!

                var textField: UITextField?
                var textView: UITextView?

                var view: UIView?

                let operatorSign: Int = (iDirectionType == .leftResponderDirectionType) ? -1 : 1
                var i: Int = currentTextFieldIndex + operatorSign

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
            }
        }
    }


    // MARK: - UITextField Delegate Methods -
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let isEditable = true
        return isEditable
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {

        self.setScrollViewContentOffsetForView(self)
        AppUtility.executeTaskInGlobalQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            var scrollView: UIScrollView? = self!.getScrollViewFromView(self!)

            if(scrollView != nil)
            {
                AppUtility.executeTaskInMainQueueWithCompletion {
                    scrollView?.isScrollEnabled = false
                    scrollView = nil
                }
            }
        }
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {

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

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            textField.resignFirstResponder()
            self!.resetScrollView()
        }
        return true
    }

    /**
     TextField delegate method for check the max character limit.
     */
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        var oldlength: Int = 0
        if textField.text != nil
            {
            oldlength = (textField.text?.count)!
        }

        let replaceMentLength: Int = string.count
        let rangeLength: Int = range.length

        let newLength: Int = oldlength - rangeLength + replaceMentLength

        return newLength <= charaterLimit || false
    }
}


