//
//  BaseView.swift
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

public typealias ControlTouchUpInsideEvent = (_ sender: AnyObject?, _ object: AnyObject?) -> ()
public typealias TableCellSelectEvent = (_ sender: AnyObject?, _ object: AnyObject?) -> ()

public typealias ScrollViewDidScrollEvent = (_ scrollView: UIScrollView?, _ object: AnyObject?) -> ()
public typealias TaskFinishedEvent = (_ successFlag: Bool?, _ object: AnyObject?) -> ()
public typealias SwitchStateChangedEvent = (_ sender: AnyObject?, _ state: Bool?) -> ()

@IBDesignable
open class BaseView: UIView {

    // MARK: - Attributes -
    /// Its object of BaseLayout Class for Mack the Constraint
    open var baseLayout: AppBaseLayout!

    /// Its for Set the Footer of TableView
    open var tableFooterView: UIView!

    /// Its for set the Backgroudimage in whole application
    var backgroundImageView: BaseImageView!

    /// Its for show the Error on View
    var errorMessageLabel: UILabel!

    /// Its for Show the Activity Indiacter at Footer of view
    open var footerIndicatorView: UIActivityIndicatorView!

    /// Its for Trackt current request is running in view or not
    open var isLoadedRequest: Bool = false

    var layoutSubViewEvent: TaskFinishedEvent!

    /// Its for maintaint the multipule API Call queue.
    open var operationQueue: OperationQueue!

    /// Its for TableView Footer Height
    open var tableFooterHeight: CGFloat = 0.0

    // MARK: - Lifecycle -
    /// Its will set corder radius of Whole Application View's
    @IBInspectable open var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable open var shadowColor: UIColor = AppColor.shadow.value {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable open var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable open var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable open var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        self.updateShadowPath()
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit {
        print("BaseView Deinit Called")
        self.releaseObject()
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object. This method is need to over ride in every chiled view for memory managment.
     */
    open func releaseObject() {

        NotificationCenter.default.removeObserver(self)

        if baseLayout != nil {
            baseLayout.releaseObject()
            baseLayout.metrics = nil
            baseLayout.viewDictionary = nil
            baseLayout = nil
        }

        if backgroundImageView != nil && backgroundImageView.superview != nil {
            backgroundImageView.removeFromSuperview()
            backgroundImageView = nil
        }
        else {
            backgroundImageView = nil
        }

        if errorMessageLabel != nil && errorMessageLabel.superview != nil {
            errorMessageLabel.removeFromSuperview()
            errorMessageLabel = nil
        }
        else {
            errorMessageLabel = nil
        }

        if tableFooterView != nil && tableFooterView.superview != nil {
            tableFooterView.removeFromSuperview()
            tableFooterView = nil
        }
        else {
            tableFooterView = nil
        }

        if footerIndicatorView != nil && footerIndicatorView.superview != nil {
            footerIndicatorView.removeFromSuperview()
            footerIndicatorView = nil
        } else {
            footerIndicatorView = nil
        }

        if(operationQueue != nil) {
            operationQueue.cancelAllOperations()
        }

        operationQueue = nil
    }

    // MARK: - Layout -
    /// This method is used for the Load the Control when initialized.
    open func loadViewControls() {

        operationQueue = OperationQueue()

        self.translatesAutoresizingMaskIntoConstraints = false
        self.isExclusiveTouch = true
        self.isMultipleTouchEnabled = true
        self.layer.masksToBounds = false

        self.updateProperties()
        self.updateShadowPath()

    }

    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColor.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
    }

    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }

    /// This method is used called after View iniit, For set the Layout constraint of subView's
    open func setViewlayout() {

        if(baseLayout == nil) {
            baseLayout = AppBaseLayout()

            baseLayout.releaseObject()
        }
    }


    /// This method is used to check internet is on or not.


    /// It will Show the Footerview at bottom of View with indiacateView
    open func loadTableFooterView() {

        let screenSize: CGSize = UIScreen.main.bounds.size

        footerIndicatorView = UIActivityIndicatorView(style: .white)
        tableFooterHeight = footerIndicatorView.frame.size.height + 20.0

        tableFooterView = UIView()
        tableFooterView.backgroundColor = UIColor.clear

        tableFooterView.frame = CGRect(x: 0.0, y: 0.0, width: screenSize.width, height: tableFooterHeight)

        let tableHeaderSize: CGSize = tableFooterView.frame.size
        footerIndicatorView.center = CGPoint(x: tableHeaderSize.width / 2.0, y: tableHeaderSize.height / 2.0)

        footerIndicatorView.startAnimating()
        footerIndicatorView.hidesWhenStopped = true

        tableFooterView.addSubview(footerIndicatorView)
    }

    // MARK: - Public Interface -

    /**
     This is will check the TextControl is first in its SuperView
     */
    open class func isFirstTextControlInSuperview(_ superview: UIView, textControl: UIView) -> Bool {

        var isFirstTextControl: Bool = true

        var textControlIndex: Int = -1
        var viewControlIndex: Int = -1

        if((superview.subviews.contains(textControl))) {
            textControlIndex = superview.subviews.firstIndex(of: textControl)!
        }

        for view in (superview.subviews) {

            if(view.isTextControl() && textControl != view) {

                viewControlIndex = superview.subviews.firstIndex(of: view)!

                if(viewControlIndex < textControlIndex) {
                    isFirstTextControl = false
                    break
                }
            }
        }

        return isFirstTextControl

    }

    /**
     This is will check the TextControl is last in its SuperView
     */
    open class func isLastTextControlInSuperview(_ superview: UIView, textControl: UIView) -> Bool {

        var isLastTextControl: Bool = true

        var textControlIndex: Int = -1
        var viewControlIndex: Int = -1

        if((superview.subviews.contains(textControl))) {
            textControlIndex = superview.subviews.firstIndex(of: textControl)!
        }

        for view in (superview.subviews) {

            if(view.isTextControl() && textControl != view) {

                viewControlIndex = superview.subviews.firstIndex(of: view)!

                if(viewControlIndex > textControlIndex) {
                    isLastTextControl = false
                    break
                }
            }
        }

        return isLastTextControl
    }

    /// This method is initialize the Background ImageView in Whole Application

    func displayBackgroundImageView(_ image: UIImage?) {

        if(backgroundImageView == nil) {

            backgroundImageView = BaseImageView(frame: CGRect.zero)

            backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            backgroundImageView.contentMode = .scaleToFill

            self.addSubview(backgroundImageView)

            if(baseLayout == nil) {
                baseLayout = AppBaseLayout()
            }

            baseLayout.expandView(backgroundImageView, insideView: self)
            baseLayout = nil
        }

        if(image != nil) {
            backgroundImageView.image = image
        }

    }


    /**
     This will Display Error message Label on View.
     - parameter errorMessage : if Message Passed Blank than errorLabel Will Hide else if message not blank than error label will show.
     */
    public func displayErrorMessageLabel(_ errorMessage: String?) {

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            if(self!.errorMessageLabel != nil) {

                self!.errorMessageLabel.isHidden = true
                self!.errorMessageLabel.text = ""

                if(self!.errorMessageLabel.tag == -1) {
                    self!.sendSubviewToBack(self!.errorMessageLabel)
                }

                if(errorMessage != nil) {

                    if(self!.errorMessageLabel.tag == -1) {
                        self!.bringSubviewToFront(self!.errorMessageLabel)
                    }

                    self!.errorMessageLabel.isHidden = false
                    self!.errorMessageLabel.text = errorMessage

                }
                self!.errorMessageLabel.layoutSubviews()
            }
            else {
                self!.errorMessageLabel = UILabel(frame: (self?.bounds)!)

                self!.errorMessageLabel.font = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h3) : .standard(.h4)).instance
                self!.errorMessageLabel.numberOfLines = 0

                self!.errorMessageLabel.preferredMaxLayoutWidth = 200
                self!.errorMessageLabel.textAlignment = .center

                self!.errorMessageLabel.backgroundColor = UIColor.clear
                self!.errorMessageLabel.textColor = AppColor.labelErrorText.withAlpha(1.0)

                self!.errorMessageLabel.tag = -1
                self!.addSubview(self!.errorMessageLabel)
                self!.displayErrorMessageLabel(errorMessage)
            }
        }
    }


    // MARK: - User Interaction -


    // MARK: - Internal Helpers -

    open func handleNetworkCheck(isAvailable: Bool, viewController from: UIView, showLoaddingView: Bool) {
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

            if self == nil {
                return
            }

            if isAvailable == true {
                if showLoaddingView == true
                    {
                    self?.makeToastActivity()
//                    BaseProgressHUD.shared.showInView(view: from)
                }

            }
            else {
                self?.isLoadedRequest = false

            }
        }
    }

    // MARK: - Server Request -

    open func loadOperationServerRequest() {

        if(!isLoadedRequest)
        {
            AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in

                if self == nil {
                    return
                }

            }
        }
    }

    open func beginServerRequest() {
        isLoadedRequest = true
    }

}

extension UIView {

    open func isShowEmptyView(_ isShow: Bool, message: String)
    {
        if isShow
            {
            //first remove old
            for view in self.subviews {
                if view.tag == 99 {
                    view.removeFromSuperview()
                    break
                }
            }

            //init
            let emptyStateView: BaseEmptyState = BaseEmptyState()
            //customize
            emptyStateView.message = message
            emptyStateView.tag = 99
            emptyStateView.buttonHidden = true
            //add subview
            self.addSubview(emptyStateView)

            //add autolayout
            emptyStateView.translatesAutoresizingMaskIntoConstraints = false

            emptyStateView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            emptyStateView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            emptyStateView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
            emptyStateView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55).isActive = true
            self.layoutIfNeeded()
        }
        else {
            for view in self.subviews {
                if view.tag == 99 {
                    view.removeFromSuperview()
                    break
                }
            }
        }
    }
}

