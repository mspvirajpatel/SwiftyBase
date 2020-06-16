//
//  BasePopOverMenu.swi
//  Pods
//
//  Created by MacMini-2 on 07/09/17.
//
//

import Foundation
import UIKit

extension BasePopOverMenu {

    public static func showForSender(sender: UIView, with menuArray: [String], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: sender, or: nil, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    public static func showForSender(sender: UIView, with menuArray: [String], menuImageArray: [UIImage], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: sender, or: nil, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }

    public static func showForEvent(event: UIEvent, with menuArray: [String], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    public static func showForEvent(event: UIEvent, with menuArray: [String], menuImageArray: [UIImage], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }

    public static func showFromSenderFrame(senderFrame: CGRect, with menuArray: [String], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: nil, or: senderFrame, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    public static func showFromSenderFrame(senderFrame: CGRect, with menuArray: [String], menuImageArray: [UIImage], done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {
        self.sharedMenu.showForSender(sender: nil, or: senderFrame, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }

    public static func dismiss() {
        self.sharedMenu.dismiss()
    }
}

public class BasePopConfiguration: NSObject {

    public var menuRowHeight: CGFloat = DefaultMenuRowHeight
    public var menuWidth: CGFloat = DefaultMenuWidth
    public var textColor: UIColor = UIColor.white
    public var textFont: UIFont = UIFont.systemFont(ofSize: 14)
    public var borderColor: UIColor = DefaultTintColor
    public var borderWidth: CGFloat = DefaultBorderWidth
    public var backgoundTintColor: UIColor = DefaultTintColor
    public var cornerRadius: CGFloat = DefaultCornerRadius
    public var textAlignment: NSTextAlignment = NSTextAlignment.left
    public var ignoreImageOriginalColor: Bool = false
    public var menuSeparatorColor: UIColor = UIColor.lightGray
    public var menuSeparatorInset: UIEdgeInsets = UIEdgeInsets(top: 0, left: DefaultCellMargin, bottom: 0, right: DefaultCellMargin)
    public var cellSelectionStyle: UITableViewCell.SelectionStyle = .none

    public static var shared: BasePopConfiguration {
        struct StaticConfig {
            static let instance: BasePopConfiguration = BasePopConfiguration()
        }
        return StaticConfig.instance
    }

}

fileprivate let DefaultMargin: CGFloat = 4
fileprivate let DefaultCellMargin: CGFloat = 6
fileprivate let DefaultMenuIconSize: CGFloat = 24
fileprivate let DefaultMenuCornerRadius: CGFloat = 4
fileprivate let DefaultMenuArrowWidth: CGFloat = 8
fileprivate let DefaultMenuArrowHeight: CGFloat = 10
fileprivate let DefaultAnimationDuration: TimeInterval = 0.2
fileprivate let DefaultBorderWidth: CGFloat = 0.5
fileprivate let DefaultCornerRadius: CGFloat = 6
fileprivate let DefaultMenuRowHeight: CGFloat = 40
fileprivate let DefaultMenuWidth: CGFloat = 120
fileprivate let DefaultTintColor: UIColor = UIColor(red: 80 / 255, green: 80 / 255, blue: 80 / 255, alpha: 1)

fileprivate let BasePopOverMenuTableViewCellIndentifier: String = "BasePopOverMenuTableViewCellIndentifier"

fileprivate enum BasePopOverMenuArrowDirection {
    case Up
    case Down
}

public class BasePopOverMenu: NSObject {

    var sender: UIView?
    var senderFrame: CGRect?
    var menuNameArray: [String]!
    var menuImageArray: [UIImage]!
    var done: ((_ selectedIndex: NSInteger) -> ())!
    var cancel: (() -> ())!

    fileprivate static var sharedMenu: BasePopOverMenu {
        struct Static {
            static let instance: BasePopOverMenu = BasePopOverMenu()
        }
        return Static.instance
    }

    fileprivate lazy var configuration: BasePopConfiguration = {
        return BasePopConfiguration.shared
    }()

    fileprivate lazy var backgroundView: UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = AppColor.custom(hexString: 0x00000, alpha: 0.1).value
        view.addGestureRecognizer(self.tapGesture)
        return view
    }()

    fileprivate lazy var popOverMenu: BasePopOverMenuView = {
        let menu = BasePopOverMenuView(frame: CGRect.zero)
        menu.alpha = 0
        self.backgroundView.addSubview(menu)
        return menu
    }()

    fileprivate var isOnScreen: Bool = false {
        didSet {
            if isOnScreen {
                self.addOrientationChangeNotification()
            } else {
                self.removeOrientationChangeNotification()
            }
        }
    }

    fileprivate lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroudViewTapped(gesture:)))
        gesture.delegate = self
        return gesture
    }()

    fileprivate func showForSender(sender: UIView?, or senderFrame: CGRect?, with menuNameArray: [String]!, menuImageArray: [UIImage]?, done: @escaping (NSInteger) -> (), cancel: @escaping () -> ()) {

        if sender == nil && senderFrame == nil {
            return
        }
        if menuNameArray.count == 0 {
            return
        }

        self.sender = sender
        self.senderFrame = senderFrame
        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.done = done
        self.cancel = cancel

        UIApplication.shared.keyWindow?.addSubview(self.backgroundView)

        self.adjustPostionForPopOverMenu()
    }

    fileprivate func adjustPostionForPopOverMenu() {
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen._width(), height: UIScreen._height())

        self.setupPopOverMenu()

        self.showIfNeeded()
    }

    fileprivate func setupPopOverMenu() {
        popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)

        self.configurePopMenuFrame()

        popOverMenu.showWithAnglePoint(point: menuArrowPoint, frame: popMenuFrame, menuNameArray: menuNameArray, menuImageArray: menuImageArray, arrowDirection: arrowDirection, done: { (selectedIndex: NSInteger) in
            self.isOnScreen = false
            self.doneActionWithSelectedIndex(selectedIndex: selectedIndex)
        })

        popOverMenu.setAnchorPoint(anchorPoint: self.getAnchorPointForPopMenu())
    }

    fileprivate func getAnchorPointForPopMenu() -> CGPoint {
        var anchorPoint = CGPoint(x: menuArrowPoint.x / popMenuFrame.size.width, y: 0)
        if arrowDirection == .Down {
            anchorPoint = CGPoint(x: menuArrowPoint.x / popMenuFrame.size.width, y: 1)
        }
        return anchorPoint
    }

    fileprivate var senderRect: CGRect = CGRect.zero
    fileprivate var popMenuOriginX: CGFloat = 0
    fileprivate var popMenuFrame: CGRect = CGRect.zero
    fileprivate var menuArrowPoint: CGPoint = CGPoint.zero
    fileprivate var arrowDirection: BasePopOverMenuArrowDirection = .Up
    fileprivate var popMenuHeight: CGFloat {
        return configuration.menuRowHeight * CGFloat(self.menuNameArray.count) + DefaultMenuArrowHeight
    }

    fileprivate func configureSenderRect() {
        if self.sender != nil {
            if sender?.superview != nil {
                senderRect = (sender?.superview?.convert((sender?.frame)!, to: backgroundView))!
            } else {
                senderRect = (sender?.frame)!
            }
        } else if senderFrame != nil {
            senderRect = senderFrame!
        }
        senderRect.origin.y = min(UIScreen._height(), senderRect.origin.y)

        if senderRect.origin.y + senderRect.size.height / 2 < UIScreen._height() / 2 {
            arrowDirection = .Up
        } else {
            arrowDirection = .Down
        }
    }

    fileprivate func configurePopMenuOriginX() {
        var senderXCenter: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth / 2 + DefaultMargin
        var menuX: CGFloat = 0
        if (senderXCenter.x + menuCenterX > UIScreen._width()) {
            senderXCenter.x = min(senderXCenter.x - (UIScreen._width() - configuration.menuWidth - DefaultMargin), configuration.menuWidth - DefaultMenuArrowWidth - DefaultMargin)
            menuX = UIScreen._width() - configuration.menuWidth - DefaultMargin
        } else if (senderXCenter.x - menuCenterX < 0) {
            senderXCenter.x = max(DefaultMenuCornerRadius + DefaultMenuArrowWidth, senderXCenter.x - DefaultMargin)
            menuX = DefaultMargin
        } else {
            senderXCenter.x = configuration.menuWidth / 2
            menuX = senderRect.origin.x + (senderRect.size.width) / 2 - configuration.menuWidth / 2
        }
        popMenuOriginX = menuX
    }

    fileprivate func configurePopMenuFrame() {
        self.configureSenderRect()
        self.configureMenuArrowPoint()
        self.configurePopMenuOriginX()

        if (arrowDirection == .Up) {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y + popMenuFrame.size.height > UIScreen._height()) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: UIScreen._height() - popMenuFrame.origin.y - DefaultMargin)
            }
        } else {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y - popMenuHeight), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y < 0) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: DefaultMargin, width: configuration.menuWidth, height: senderRect.origin.y - DefaultMargin)
            }
        }
    }

    fileprivate func configureMenuArrowPoint() {
        var point: CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width) / 2, y: 0)
        let menuCenterX: CGFloat = configuration.menuWidth / 2 + DefaultMargin
        if senderRect.origin.y + senderRect.size.height / 2 < UIScreen._height() / 2 {
            point.y = 0
        } else {
            point.y = popMenuHeight
        }
        if (point.x + menuCenterX > UIScreen._width()) {
            point.x = min(point.x - (UIScreen._width() - configuration.menuWidth - DefaultMargin), configuration.menuWidth - DefaultMenuArrowWidth - DefaultMargin)
        } else if (point.x - menuCenterX < 0) {
            point.x = max(DefaultMenuCornerRadius + DefaultMenuArrowWidth, point.x - DefaultMargin)
        } else {
            point.x = configuration.menuWidth / 2
        }
        menuArrowPoint = point
    }

    @objc fileprivate func onBackgroudViewTapped(gesture: UIGestureRecognizer) {
        self.dismiss()
    }

    fileprivate func showIfNeeded() {
        if self.isOnScreen == false {
            self.isOnScreen = true
            popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: DefaultAnimationDuration, animations: {
                self.popOverMenu.alpha = 1
                self.popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }

    fileprivate func dismiss() {
        self.isOnScreen = false
        self.doneActionWithSelectedIndex(selectedIndex: -1)
    }

    fileprivate func doneActionWithSelectedIndex(selectedIndex: NSInteger) {
        UIView.animate(withDuration: DefaultAnimationDuration,
                       animations: {
                           self.popOverMenu.alpha = 0
                           self.popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                       }) { (isFinished) in
            if isFinished {
                self.backgroundView.removeFromSuperview()
                if selectedIndex < 0 {
                    if (self.cancel != nil) {
                        self.cancel()
                    }
                } else {
                    if (self.done != nil) {
                        self.done(selectedIndex)
                    }
                }

            }
        }
    }

}
extension UIControl {

    // solution found at: http://stackoverflow.com/a/5666430/6310268

    fileprivate func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)

        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)

        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x

        position.y -= oldPoint.y
        position.y += newPoint.y

        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }

}

extension BasePopOverMenu {

    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)

    }

    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }

    @objc fileprivate func onChangeStatusBarOrientationNotification(notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.adjustPostionForPopOverMenu()
        })
    }

}

extension BasePopOverMenu: UIGestureRecognizerDelegate {

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: backgroundView)
        let touchClass: String = NSStringFromClass((touch.view?.classForCoder)!) as String
        if touchClass == "UITableViewCellContentView" {
            return false
        } else if CGRect(x: 0, y: 0, width: configuration.menuWidth, height: configuration.menuRowHeight).contains(touchPoint) {
            // when showed at the navgation-bar-button-item, there is a chance of not respond around the top arrow, so :
            self.doneActionWithSelectedIndex(selectedIndex: 0)
            return false
        }
        return true
    }

}

private class BasePopOverMenuView: UIControl {

    fileprivate var menuNameArray: [String]!
    fileprivate var menuImageArray: [UIImage]?
    fileprivate var arrowDirection: BasePopOverMenuArrowDirection = .Up
    fileprivate var done: ((NSInteger) -> ())!

    fileprivate lazy var configuration: BasePopConfiguration = {
        return BasePopConfiguration.shared
    }()

    lazy var menuTableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = BasePopConfiguration.shared.menuSeparatorColor
        tableView.layer.cornerRadius = BasePopConfiguration.shared.cornerRadius
        tableView.clipsToBounds = true
        return tableView
    }()

    fileprivate func showWithAnglePoint(point: CGPoint, frame: CGRect, menuNameArray: [String]!, menuImageArray: [UIImage]!, arrowDirection: BasePopOverMenuArrowDirection, done: @escaping ((NSInteger) -> ())) {

        self.frame = frame



        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.arrowDirection = arrowDirection
        self.done = done

        self.repositionMenuTableView()

        self.drawBackgroundLayerWithArrowPoint(arrowPoint: point)
    }

    fileprivate func repositionMenuTableView() {
        var menuRect: CGRect = CGRect(x: 0, y: DefaultMenuArrowHeight, width: self.frame.size.width, height: self.frame.size.height - DefaultMenuArrowHeight)
        if (arrowDirection == .Down) {
            menuRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - DefaultMenuArrowHeight)
        }
        self.menuTableView.frame = menuRect
        self.menuTableView.reloadData()
        if menuTableView.frame.height < configuration.menuRowHeight * CGFloat(menuNameArray.count) {
            self.menuTableView.isScrollEnabled = true
        } else {
            self.menuTableView.isScrollEnabled = false
        }
        self.addSubview(self.menuTableView)
    }

    fileprivate lazy var backgroundLayer: CAShapeLayer = {
        let layer: CAShapeLayer = CAShapeLayer()
        return layer
    }()


    fileprivate func drawBackgroundLayerWithArrowPoint(arrowPoint: CGPoint) {
        if self.backgroundLayer.superlayer != nil {
            self.backgroundLayer.removeFromSuperlayer()
        }

        backgroundLayer.path = self.getBackgroundPath(arrowPoint: arrowPoint).cgPath
        backgroundLayer.fillColor = configuration.backgoundTintColor.cgColor
        backgroundLayer.strokeColor = configuration.borderColor.cgColor
        backgroundLayer.lineWidth = configuration.borderWidth
        self.layer.insertSublayer(backgroundLayer, at: 0)
        //        backgroundLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(M_PI))) //CATransform3DMakeRotation(CGFloat(M_PI), 1, 1, 0)
    }

    func getBackgroundPath(arrowPoint: CGPoint) -> UIBezierPath {
        let radius: CGFloat = configuration.cornerRadius / 2

        let path: UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        if (arrowDirection == .Up) {
            path.move(to: CGPoint(x: arrowPoint.x - DefaultMenuArrowWidth, y: DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            path.addLine(to: CGPoint(x: arrowPoint.x + DefaultMenuArrowWidth, y: DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: self.bounds.size.width - radius, y: DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - radius))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2,
                        clockwise: true)
            path.addLine(to: CGPoint(x: radius, y: self.bounds.size.height))
            path.addArc(withCenter: CGPoint(x: radius, y: self.bounds.size.height - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: .pi,
                        clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: DefaultMenuArrowHeight + radius))
            path.addArc(withCenter: CGPoint(x: radius, y: DefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2 * 3,
                        clockwise: true)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: DefaultMenuArrowHeight, width: self.bounds.size.width, height: self.bounds.height - DefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - DefaultMenuArrowWidth, y: DefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + DefaultMenuArrowWidth, y: DefaultMenuArrowHeight))
            //            path.close()
        } else {
            path.move(to: CGPoint(x: arrowPoint.x - DefaultMenuArrowWidth, y: self.bounds.size.height - DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: self.bounds.size.height))
            path.addLine(to: CGPoint(x: arrowPoint.x + DefaultMenuArrowWidth, y: self.bounds.size.height - DefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - DefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi / 2,
                        endAngle: 0,
                        clockwise: false)
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: radius))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: .pi / 2 * 3,
                        clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addArc(withCenter: CGPoint(x: radius, y: radius),
                        radius: radius,
                        startAngle: .pi / 2 * 3,
                        endAngle: .pi,
                        clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: self.bounds.size.height - DefaultMenuArrowHeight - radius))
            path.addArc(withCenter: CGPoint(x: radius, y: self.bounds.size.height - DefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: .pi,
                        endAngle: .pi / 2,
                        clockwise: false)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height - DefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - DefaultMenuArrowWidth, y: self.bounds.size.height - DefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: self.bounds.size.height))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + DefaultMenuArrowWidth, y: self.bounds.size.height - DefaultMenuArrowHeight))
            //            path.close()
        }
        return path
    }



}

extension BasePopOverMenuView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configuration.menuRowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.done != nil) {
            self.done(indexPath.row)
        }
    }

}

extension BasePopOverMenuView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuNameArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BasePopOverMenuCell = BasePopOverMenuCell(style: .default, reuseIdentifier: BasePopOverMenuTableViewCellIndentifier)
        var imageName: UIImage?
        if menuImageArray != nil {
            if (menuImageArray?.count)! >= indexPath.row + 1 {
                imageName = (menuImageArray?[indexPath.row])!
            }
        }
        cell.setupCellWith(menuName: menuNameArray[indexPath.row], menuImage: imageName)
        if (indexPath.row == menuNameArray.count - 1) {
            cell.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        } else {
            cell.separatorInset = configuration.menuSeparatorInset
        }
        cell.selectionStyle = configuration.cellSelectionStyle
        return cell
    }

}

class BasePopOverMenuCell: UITableViewCell {

    fileprivate lazy var configuration: BasePopConfiguration = {
        return BasePopConfiguration.shared
    }()

    fileprivate lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()

    fileprivate lazy var nameLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        self.contentView.addSubview(label)
        return label
    }()

    fileprivate func setupCellWith(menuName: String, menuImage: UIImage?) {
        self.backgroundColor = UIColor.clear
        if menuImage != nil {
            if var iconImage: UIImage = menuImage {
                if configuration.ignoreImageOriginalColor {
                    iconImage = iconImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                }
                iconImageView.tintColor = configuration.textColor
                iconImageView.frame = CGRect(x: DefaultCellMargin, y: (configuration.menuRowHeight - DefaultMenuIconSize) / 2, width: DefaultMenuIconSize, height: DefaultMenuIconSize)
                iconImageView.image = iconImage
                nameLabel.frame = CGRect(x: DefaultCellMargin * 2 + DefaultMenuIconSize, y: (configuration.menuRowHeight - DefaultMenuIconSize) / 2, width: (configuration.menuWidth - DefaultMenuIconSize - DefaultCellMargin * 3), height: DefaultMenuIconSize)
                } else {
                    nameLabel.frame = CGRect(x: DefaultCellMargin, y: 0, width: configuration.menuWidth - DefaultCellMargin * 2, height: configuration.menuRowHeight)
                }
            }
            else
            {
                nameLabel.frame = CGRect(x: DefaultCellMargin, y: 0, width: configuration.menuWidth - DefaultCellMargin * 2, height: configuration.menuRowHeight)
            }
            nameLabel.font = configuration.textFont
            nameLabel.textColor = configuration.textColor
            nameLabel.textAlignment = configuration.textAlignment
            nameLabel.text = menuName
        }

    }

    extension UIScreen {

        public static func _width() -> CGFloat {
            return self.main.bounds.size.width
        }
        public static func _height() -> CGFloat {
            return self.main.bounds.size.height
        }

    }


//

//let configuration = AppConfiguration.shared
//configuration.menuRowHeight = ...
//    configuration.menuWidth = ...
//    configuration.textColor = ...
//    configuration.textFont = ...
//    configuration.tintColor = ...
//    configuration.borderColor = ...
//    configuration.borderWidth = ...
//    configuration.textAlignment = ...
//    configuration.ignoreImageOriginalColor = ...;
//// set 'ignoreImageOriginalColor' to YES, images color will be same as textColor
//From SenderView, Menu Without Images.
//
//BasePopOverMenu.showForSender(sender: sender,
//with: ["Share"],
//done: { (selectedIndex) -> () in
//
//print(selectedIndex)
//}) {
//
//}
//From SenderView, Menu With Images.
//
//BasePopOverMenu.showForSender(sender: sender,
//with: ["Share"],
//menuImageArray: ["iconImageName"],
//done: { (selectedIndex) -> () in
//
//print(selectedIndex)
//}) {
//
//}
//From SenderFrame/NavigationItem, Menu Without Images.
//
//BasePopOverMenu.showFromSenderFrame(senderFrame: sender.frame,
//with: ["Share"],
//done: { (selectedIndex) -> () in
//
//}) {
//
//}
//From SenderFrame/NavigationItem, Menu With Images.
//
//BasePopOverMenu.showFromSenderFrame(senderFrame: sender.frame,
//with: ["Share"],
//menuImageArray: ["iconImageName"],
//done: { (selectedIndex) -> () in
//
//}) {
//
//}
//From barButtonItems .
//
//First: add action with event to you barButtonItems
//@IBAction func handleAddBarButtonItem(_ sender: UIBarButtonItem, event: UIEvent) {
//
//    BasePopOverMenu.showForEvent(event: event,
//                               with: ["Share"],
//                               menuImageArray: ["iconImageName"],
//                               done: { (selectedIndex) -> () in
//
//    }) {
//
//    }
//}
