//
//  BaseButton.swift
//  Pods
//
//  Created by MacMini-2 on 31/08/17.
//
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import Foundation

/**
 This is List of Base Button Type. If want to add new type just define in this and Handle that type in BaseButton Class.
 
 - default unknown: this is default type
 
 */
public enum BaseButtonType: Int {

    case unknown = -1
    case primary = 1
    case secondary
    case radio
    case roundedClose
    case close
    case transparent
    case checkbox
    case dropDown

    case none

    init(named baseButtonType: String) {
        switch baseButtonType
        {
        case "unknown": self = .unknown
            break
        case "primary": self = .primary
            break
        case "secondary": self = .secondary
            break
        case "radio": self = .radio
            break
        case "roundedClose": self = .roundedClose
            break
        case "close": self = .close
            break
        case "transparent": self = .transparent
            break
        case "checkbox": self = .checkbox
            break
        case "dropDown": self = .dropDown
            break
        default: self = .none
            break
        }
    }

}


/**
 This is Base Class of BaseButton. Use this class in whole application where you want to use button.
 */
open class BaseButton: UIButton
{
    // MARK: - Attributes -
    /**
     Store the type of Base Button. its private. Default value is unknown
     */
    open var baseButtonType: BaseButtonType = .unknown
    /**
     Store the BackgroundColor.
     */
    private var originalBackgroundColor: UIColor!
    private var highlightBackgroundColor: UIColor!
    /**
     Button's TouchUp Event Block.
     */
    public var touchUpInsideEvent: ControlTouchUpInsideEvent!

    // MARK: - For Radio Button
    fileprivate var circleLayer: CAShapeLayer! = CAShapeLayer()
    fileprivate var fillCircleLayer: CAShapeLayer! = CAShapeLayer()

    @IBInspectable var ButtonType: String? {
        willSet {
            baseButtonType = BaseButtonType(named: newValue ?? "")
            self.setCommonProperties()

        }
    }

    override open var isSelected: Bool {
        didSet {
            toggleButon()
        }
    }

    /**
     Color of the radio button circle. Default value is UIColor red.
     */
    @IBInspectable open var circleColor: UIColor! = UIColor.red {
        didSet {
            if circleColor != nil {
                circleLayer.strokeColor = circleColor.cgColor
                self.toggleButon()
            }
        }
    }

    /**
     Radius of RadioButton circle.
     */
    open var circleRadius: CGFloat! = 5.0

    open var cornerButtonRadius: CGFloat! {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    fileprivate func circleFrame() -> CGRect {
        var circleFrame = CGRect(x: 0, y: 0, width: 2 * circleRadius, height: 2 * circleRadius)
        circleFrame.origin.x = 0 + circleLayer.lineWidth
        circleFrame.origin.y = bounds.height / 2 - circleFrame.height / 2
        return circleFrame
    }


    /**
     Toggles selected state of the button.
     */
    open func toggleButon() {
        if self.isSelected {
            fillCircleLayer.fillColor = circleColor.cgColor
        } else {
            fillCircleLayer.fillColor = UIColor.clear.cgColor
        }
    }

    fileprivate func circlePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame())
    }

    fileprivate func fillCirclePath() -> UIBezierPath {
        return UIBezierPath(ovalIn: circleFrame().insetBy(dx: 2, dy: 2))
    }


    // MARK: - Lifecycle -
    public init(type: UIButtonType) {
        super.init(frame: CGRect.zero)
    }

    /**
     Init method of BaseButton
     - parameter type: Give the button's type. Ex. BaseButtonType.primary
     */
    public init(type: BaseButtonType) {
        super.init(frame: CGRect.zero)
        baseButtonType = type
        self.setCommonProperties()
        self.setlayout()
    }

    /**
     Init method of BaseButton with SuperView object
     - parameter Type : Give the button's type. Ex. BaseButtonType.primary
     - parameter iSuperView : Object of Button's superview. If its nil than button will not added in this view otherwise button will be added as subview.
     */
    public init(ibuttonType: BaseButtonType, iSuperView: UIView?) {
        super.init(frame: CGRect.zero)

        baseButtonType = ibuttonType
        self.setCommonProperties()
        self.setlayout()

        if(iSuperView != nil) {
            iSuperView?.addSubview(self)
        }
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    /**
     Its will free the memory of basebutton's current hold object's. Mack every object nill her which is declare in class as Swift not automattically release the object.
     */
    deinit
    {
        originalBackgroundColor = nil
        highlightBackgroundColor = nil
        touchUpInsideEvent = nil
        circleLayer = nil
        fillCircleLayer = nil
        circleColor = nil
        circleRadius = nil
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        self.setCommonProperties()
    }

    /**
     Here we had override the layoutSubviews method for do the layout work when its called. its necessory, when useing the Autolayout Because here he we get the actual / real frame of view.
     */
    override open func layoutSubviews() {
        super.layoutSubviews()

        switch baseButtonType {
        case .radio:
            circleLayer.frame = bounds
            circleLayer.path = circlePath().cgPath
            fillCircleLayer.frame = bounds
            fillCircleLayer.path = fillCirclePath().cgPath
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)

            break
        default:

            break
        }
    }

    // MARK: - Layout -
    /**
     This method is called from Init method. its will set the Common properties like backgroundcolor, text color, font  and border according to type.
     */
    open func setCommonProperties() {

        self.isExclusiveTouch = false
        self.translatesAutoresizingMaskIntoConstraints = false

        switch baseButtonType
        {

        case .primary:

            self.backgroundColor = AppColor.buttonPrimaryBG.value
            self.setTitleColor(AppColor.buttonPrimaryTitle.value, for: UIControlState())
            self.titleLabel?.font = Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            //For set Border
            self.setBorder(AppColor.buttonBorder.value, width: 1.5, radius: ControlConstant.borderRadius)

            break

        case .secondary:

            self.backgroundColor = AppColor.buttonSecondaryBG.value
            self.setTitleColor(AppColor.buttonSecondaryTitle.value, for: UIControlState())
            self.titleLabel?.font = Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            self.setBorder(AppColor.buttonBorder.value, width: 1.5, radius: ControlConstant.borderRadius)
            break

        case .transparent:

            self.backgroundColor = UIColor.clear
            self.setTitleColor(AppColor.buttonPrimaryTitle.value, for: .normal)
            self.titleLabel?.font = currentDevice.isIpad ? Font(.installed(.AppleMedium), size: .standard(.h2)).instance : Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            break


        case .radio:

            circleLayer.frame = bounds
            circleLayer.lineWidth = 2
            circleLayer.fillColor = UIColor.clear.cgColor
            circleLayer.strokeColor = circleColor.cgColor
            layer.addSublayer(circleLayer)
            fillCircleLayer.frame = bounds
            fillCircleLayer.lineWidth = 2
            fillCircleLayer.fillColor = UIColor.clear.cgColor
            fillCircleLayer.strokeColor = UIColor.clear.cgColor
            layer.addSublayer(fillCircleLayer)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0)
            self.toggleButon()
            self.setTitleColor(AppColor.buttonPrimaryTitle.value, for: UIControlState())
            self.circleColor = AppColor.buttonPrimaryBG.value
            self.titleLabel?.font = Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.contentHorizontalAlignment = .left
            self.circleRadius = 10.0
            break

        case .roundedClose:

            self.backgroundColor = AppColor.buttonPrimaryBG.value
            self.setTitleColor(AppColor.buttonPrimaryTitle.value, for: .normal)
            self.titleLabel?.font = currentDevice.isIpad ? Font(.installed(.AppleMedium), size: .standard(.h2)).instance : Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0)
            self.setBorder(AppColor.buttonBorder.value, width: 1.0, radius: ControlConstant.borderRadius)
            break

        case .checkbox:

            self.backgroundColor = AppColor.buttonSecondaryBG.value
            self.setImage(UIImage(named: ""), for: UIControlState.normal)
            self.setImage(UIImage(named: ""), for: UIControlState.highlighted)
            self.layer.borderColor = AppColor.buttonBorder.value.cgColor
            self.layer.borderWidth = 1.0
//            self.setFAIcon(icon: FAType.FACheck, iconSize: 20.0, forState: UIControlState.normal)

            break

        case .close:

            self.backgroundColor = UIColor.clear
//            self.setFAIcon(icon: FAType.FAClose, iconSize: 20.0, forState: UIControlState.normal)
//            self.setFAIcon(icon: FAType.FAClose, iconSize: 20.0, forState: UIControlState.highlighted)
            self.layer.cornerRadius = 20.0
            self.clipsToBounds = true
            break

        case .dropDown:

            self.backgroundColor = AppColor.buttonSecondaryBG.value
            self.setTitleColor(AppColor.buttonPrimaryTitle.value, for: .normal)
            self.titleLabel?.font = Font(.installed(.AppleMedium), size: .standard(.h3)).instance
            self.titleEdgeInsets = UIEdgeInsetsMake(3, 10, 0, 35)
            self.contentHorizontalAlignment = .left
            break

        default:
            break
        }

        originalBackgroundColor = self.backgroundColor

        if originalBackgroundColor != nil
            {
            highlightBackgroundColor = originalBackgroundColor.darkerColorForColor()
        }

        self.addTarget(self, action: #selector(buttonTouchUpInsideAction), for: .touchUpInside)
        self.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchUpOutside)
        self.addTarget(self, action: #selector(buttonTouchUpOutsideAction), for: .touchCancel)
        self.addTarget(self, action: #selector(buttonTouchDownAction), for: .touchDown)
    }

    /**
     This method is called from init method and set the layout related thing like default heigt and width of Button as per type.
     */
    open func setlayout() {

        var baseLayout: AppBaseLayout!
        baseLayout = AppBaseLayout()

        baseLayout.viewDictionary = ["button": self]

        var buttonHeight: CGFloat!
        buttonHeight = 35.0

        switch baseButtonType {

        case .transparent:

            buttonHeight = 20.0
            break

        case .checkbox:

            buttonHeight = 30.0
            break

        case .roundedClose:

            buttonHeight = 30.0
            break

        case .close:

            buttonHeight = currentDevice.isIpad ? 60.0 : 40.0
            break

        case .radio:

            buttonHeight = 40.0
            break
        default:
            break
        }

        switch baseButtonType {

        case .primary,
             .secondary:

            baseLayout.metrics = ["buttonHeight": buttonHeight]

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            self.addConstraints(baseLayout.control_H)

            break

        case .dropDown:

            var dropDownIcon: UILabel!
            dropDownIcon = UILabel()
            dropDownIcon .font = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h3) : .standard(.h4)).instance
//            dropDownIcon .setFAIcon(icon: FAType.FAChevronDown, iconSize: 20.0)
//            dropDownIcon .setFAColor(color: AppColor.buttonPrimaryTitle.value)
            dropDownIcon.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(dropDownIcon)

            baseLayout.viewDictionary = ["button": self, "dropDownIcon": dropDownIcon]
            baseLayout.metrics = ["buttonHeight": buttonHeight, "iconSize": 20.0]

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
            self.addConstraints(baseLayout.control_H)


            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[dropDownIcon]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            baseLayout.position_Right = NSLayoutConstraint(item: dropDownIcon, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: -5.0)

            baseLayout.size_Width = NSLayoutConstraint(item: dropDownIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: 20.0)

            self.addConstraint(baseLayout.size_Width)
            self.addConstraints(baseLayout.control_V)
            self.addConstraint(baseLayout.position_Right)

            dropDownIcon = nil

            break

        case .checkbox:

            baseLayout.metrics = ["buttonHeight": buttonHeight]

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)

            break

        case .roundedClose, .close:

            baseLayout.metrics = ["buttonHeight": buttonHeight]

            baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:[button(buttonHeight)]", options: NSLayoutFormatOptions(rawValue: 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)

            self.addConstraints(baseLayout.control_H)
            self.addConstraints(baseLayout.control_V)
            break

        default:
            break
        }

        baseLayout.releaseObject()
        baseLayout = nil
        buttonHeight = nil
    }

    // MARK: - Public Interface -
    /**
     This method is used to get the touch up event of Button in its respective view and superview.
     - parameter event: its Set the event block to touchUp event and execute when button clicked.
     */
    open func setButtonTouchUpInsideEvent(_ event: @escaping ControlTouchUpInsideEvent) {

        originalBackgroundColor = self.backgroundColor
        touchUpInsideEvent = event
    }

    // MARK: - User Interaction -
    /**
     This method is Target method of button when button clicke, touchup inside etc. Its execute the TouchUp block and control passed to resepective view and viewcontroller where it's set.
     - parameter sender: Object of clicked button.
     */
    @objc open func buttonTouchUpInsideAction(_ sender: AnyObject)
    {
        self.backgroundColor = originalBackgroundColor
        switch baseButtonType
        {
        case .checkbox:
            self.isSelected = !self.isSelected
            break
        default:
            break
        }

        if(touchUpInsideEvent != nil) {
            touchUpInsideEvent(sender, "" as AnyObject)
        }
    }

    /**
     This method is occure after Button's touchup inside event occure.
     */
    @objc private func buttonTouchUpOutsideAction(_ sender: AnyObject) {
        self.backgroundColor = originalBackgroundColor
    }

    /**
     This method is occure before Button's touchUp Inside Event occure.
     */
    @objc private func buttonTouchDownAction(_ sender: AnyObject) {
        self.backgroundColor = highlightBackgroundColor
    }

    // MARK: - Internal Helpers -
}
