//
//  BaseViewController.swift
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

public extension UIViewController {

    struct AssociatedKeys {
        static var viewWillAppearOnceKey = "once_viewWillAppear"
        static var viewDidAppearOnceKey = "once_viewDidAppear"
    }

    func getBookValue(key: UnsafeRawPointer) -> Bool {
        return (objc_getAssociatedObject(self, key) as? Bool) ?? false
    }

    func setBoolValue(key: UnsafeRawPointer, value: AnyObject?) {
        if getBookValue(key: key) { return }
        objc_setAssociatedObject(self, key, value, .OBJC_ASSOCIATION_RETAIN)
    }

    var alreadyCalledViewWillAppearOnce: Bool {
        get {
            return getBookValue(key: &AssociatedKeys.viewWillAppearOnceKey)
        }
        set {
            setBoolValue(key: &AssociatedKeys.viewWillAppearOnceKey, value: newValue as AnyObject?)
        }
    }

    var alreadyCalledViewDidAppearOnce: Bool {
        get {
            return getBookValue(key: &AssociatedKeys.viewDidAppearOnceKey)
        }
        set {
            setBoolValue(key: &AssociatedKeys.viewDidAppearOnceKey, value: newValue as AnyObject?)
        }
    }

    func callOnce(flag: inout Bool, closure: () -> Void) {
        if !flag {
            closure()
            flag = true
        }
    }

    func viewWillAppearOnce(fromFunction: String = #function, closure: () -> Void) {
        guard fromFunction == "viewWillAppear" else {
            return
        }
        callOnce(flag: &alreadyCalledViewWillAppearOnce, closure: closure)
    }

    func viewDidAppearOnce(fromFunction: String = #function, closure: () -> Void) {
        guard fromFunction == "viewDidAppear" else {
            return
        }
        callOnce(flag: &alreadyCalledViewDidAppearOnce, closure: closure)
    }

}


@IBDesignable
open class BaseViewController: UIViewController, UINavigationControllerDelegate {

    open var baseLayout: AppBaseLayout!
    open var aView: BaseView!

    open var btnName: UIButton!
    open var navigationTitleString: String!

    @IBInspectable open var TitleNavigation: String {
        get {
            return self.navigationItem.title!
        }
        set {
            self.navigationItem.title = newValue
            navigationTitleString = newValue
        }
    }

    @IBInspectable open var displayMenu: Bool
    {
        get {
            return self.displayMenu
        }
        set {
            self.displayMenuButton(image: nil)
        }
    }


    // MARK: - Lifecycle -
    override open func awakeFromNib() {

    }

    required public init() {
        super.init(nibName: nil, bundle: nil)
    }

    required public init(iView: BaseView) {
        super.init(nibName: nil, bundle: nil)
        aView = iView
    }

    required public init(iView: BaseView, andNavigationTitle titleString: String) {

        super.init(nibName: nil, bundle: nil)
        aView = iView

        navigationTitleString = titleString
        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }

    init(titleString: String) {

        super.init(nibName: nil, bundle: nil)

        navigationTitleString = titleString

        AppUtility.executeTaskInMainQueueWithCompletion {
            self.navigationItem.title = self.navigationTitleString
        }

        modalPresentationStyle = .custom
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.loadViewControls()
        self.setViewlayout()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }
            self!.navigationItem.title = self!.navigationTitleString
        }
    }

    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        AppUtility.executeTaskInMainQueueWithCompletion { [weak self] in
            if self == nil {
                return
            }

            self!.navigationItem.title = self!.navigationTitleString
            self!.aView.endEditing(true)
        }
    }

    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    deinit {

        print("BaseView Controller Deinit Called")
        NotificationCenter.default.removeObserver(self)

        if aView != nil && aView.superview != nil {
            aView.releaseObject()
            aView.removeFromSuperview()
            aView = nil
        }

        if baseLayout != nil {
            baseLayout.releaseObject()
            baseLayout = nil
        }

        navigationTitleString = nil
    }

    // MARK: - Layout -

    open func loadViewControls() {

        self.view.backgroundColor = AppColor.appPrimaryBG.value
        self.view.addSubview(aView)
        self.view.isExclusiveTouch = true
        self.view.isMultipleTouchEnabled = true
    }

    open func setViewlayout() {

        /*  baseLayout Allocation   */
        baseLayout = AppBaseLayout()
    }

    public func expandViewInsideView() {
        baseLayout.expandView(aView, insideView: self.view)
    }


    // MARK: - Public Interface -

    public func displayMenuButton(image: UIImage?) {
        if image == nil {
            let barButtonItem = BaseDrawerMenuItem(target: self, action: #selector(openslider))

            self.navigationItem.leftBarButtonItem = barButtonItem

            return
        }
        var origImage: UIImage? = image
        var tintedImage: UIImage? = origImage!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)

        btnName = UIButton()
        btnName.setImage(tintedImage!, for: UIControl.State())
        btnName.tintColor = UIColor.white
        btnName.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnName.addTarget(self, action: #selector(openslider), for: .touchUpInside)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnName)

        origImage = nil
        tintedImage = nil
    }

    @objc public func openslider() {
        self.view.endEditing(true)
        self.present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)
    }

    public func HideMenuButton() {
        self.navigationItem.leftBarButtonItem = nil
    }

    // MARK: - User Interaction -

    //MARK:- After DidLayout Actions

    override open func viewDidLayoutSubviews() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(BaseViewController.didFinishLayout), object: nil)
        self.perform(#selector(BaseViewController.didFinishLayout), with: nil, afterDelay: 0)
    }

    //When all subviews finish layout...

    @objc func didFinishLayout() {

        //Does nothing, as this method will be overriden in the subclasses, if it is required.
    }

    // MARK: - Internal Helpers -

    // MARK: - Internal Helpers -


    // Mark - UINavigationControllerDelegate

}
