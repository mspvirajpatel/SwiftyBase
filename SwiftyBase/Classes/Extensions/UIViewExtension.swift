//
//  UIViewExtension.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation
import UIKit

// MARK: - UIView Extension -

private var activityIndicatorAssociationKey: UInt8 = 0

public extension UIView {
   
    func convertLocalizables() {
        if subviews.isEmpty {
            return
        }
        
        for aSubview: UIView in subviews {
            if let aTextField = aSubview as? UITextField {
                aTextField.text = NSLocalizedString(aTextField.text!, comment: "")
                if let placeholder = aTextField.placeholder {
                    aTextField.placeholder = NSLocalizedString(placeholder, comment: "")
                }
            } else if let aTextView = aSubview as? UITextView {
                if let text = aTextView.text {
                    aTextView.text = NSLocalizedString(text, comment: "")
                }
            } else if let aButton = aSubview as? UIButton {
                aButton.titleLabel?.text = NSLocalizedString((aButton.titleLabel?.text)!, comment: "")
            } else {
                aSubview.convertLocalizables()
            }
        }
    }
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var y: CGFloat{
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    
    var height: CGFloat{
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    
    var bottom: CGFloat{
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - self.frame.size.height
            self.frame = frame
        }
    }
    
    
    var right: CGFloat{
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.origin.x = newValue - self.frame.size.width
            self.frame = frame
        }
    }
    
    var size: CGSize{
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var centerPoint: CGPoint{
        get {
            return self.center
        }
        
        set {
            var center = self.center
            center = newValue
            self.center = center
        }
    }
    
    var centerX: CGFloat{
        get {
            return self.center.x
        }
        
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
    }
    
    
    var centerY: CGFloat{
        get {
            return self.center.y
        }
        
        set {
            var center = self.center
            center.y = newValue
            self.center = center
        }
    }
    
    var top: CGFloat{
        get {
            return self.frame.origin.y
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    
    var left: CGFloat{
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
   
    var origin: CGPoint{
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var activityIndicat: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func showActivityIndicator() {
        
        if (self.activityIndicat == nil) {
            self.activityIndicat = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
            
            self.activityIndicat.hidesWhenStopped = true
            self.activityIndicat.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
            self.activityIndicat.style = UIActivityIndicatorView.Style.whiteLarge
            self.activityIndicat.center = CGPoint.init(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.activityIndicat.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            
            self.activityIndicat.isUserInteractionEnabled = false
            self.activityIndicat.color = #colorLiteral(red: 0.1294117647, green: 0.5882352941, blue: 0.9529411765, alpha: 1)
            OperationQueue.main.addOperation({
                self.addSubview(self.activityIndicat)
                self.activityIndicat.startAnimating()
            })
        }
    }
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation({
            if self.activityIndicat != nil
            {
                self.activityIndicat.stopAnimating()
            }
        })
    }
    
    func applyGradient(colours: [UIColor])  {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func hideShadow() {
        self.layer.shadowOpacity = 0
    }

    func roundCorner(_ radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    func isTextControl() -> Bool{
        return (self.isTextFieldControl() || self.isTextViewControl())
    }
    
    func isTextFieldControl() -> Bool{
        return self.isKind(of: UITextField.self)
    }
    
    func isTextViewControl() -> Bool{
        return self.isKind(of: UITextView.self)
    }
    
    func getRequestDictionaryFromView() -> [String: String]{
        
        var textControl : AnyObject?
        var textFromTextControl : String?
        var requestKey : String?
        
        var requestDictionary : [String: String] = Dictionary()
        
        for view in self.subviews {
            
            if(view.isTextControl()){
                
                if(view.isTextFieldControl()){
                    
                    textControl = view as? UITextField
                    textFromTextControl = textControl!.text
                    
                }else if(view.isTextViewControl()){
                    
                    textControl = view as? UITextView
                    textFromTextControl = textControl!.text
                    
                }
                
                requestKey = view.layer.value(forKey: ControlConstant.controlKey) as? String
                if(requestKey != nil && textFromTextControl != nil){
                    
                    requestDictionary[requestKey!] = textFromTextControl
                    
                }
                
            }
            
        }
        
        textControl = nil
        textFromTextControl = nil
        requestKey = nil
        
        return requestDictionary
        
    }
    
    func getDictionaryOfVariableBindings(superView : UIView , viewDic : NSDictionary) -> NSDictionary
    {
        var dicView : NSMutableDictionary = viewDic.mutableCopy() as! NSMutableDictionary
        
        if superView.subviews.count > 0
        {
            if let viewName = superView.layer .value(forKeyPath: ControlConstant.name) as? String
            {
                dicView .setValue(superView, forKey: viewName)
            }
            
            for view in superView.subviews
            {
                if view.subviews.count > 0
                {
                    dicView = self.getDictionaryOfVariableBindings(superView: view , viewDic: dicView) .mutableCopy() as! NSMutableDictionary
                }
                else
                {
                    if let viewName = view.layer .value(forKeyPath: ControlConstant.name) as? String{
                        dicView .setValue(view, forKey: viewName)
                    }
                }
            }
        }
        else
        {
            if let viewName = superView.layer .value(forKeyPath: ControlConstant.name) as? String{
                dicView .setValue(superView, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    func fillSuperview() {
        guard let superview = self.superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
    
    func anchor(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) {
        
        _ = anchorWithReturnAnchors(top, left: left, bottom: bottom, right: right, topConstant: topConstant, leftConstant: leftConstant, bottomConstant: bottomConstant, rightConstant: rightConstant, widthConstant: widthConstant, heightConstant: heightConstant)
    }
    
    func anchorWithReturnAnchors(_ top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        if self.superview == nil {
            return []
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            let constraint = topAnchor.constraint(equalTo: top, constant: topConstant)
            constraint.identifier = "top"
            anchors.append(constraint)
        }
        
        if let left = left {
            let constraint = leftAnchor.constraint(equalTo: left, constant: leftConstant)
            constraint.identifier = "left"
            anchors.append(constraint)
        }
        
        if let bottom = bottom {
            let constraint = bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant)
            constraint.identifier = "bottom"
            anchors.append(constraint)
        }
        
        if let right = right {
            let constraint = rightAnchor.constraint(equalTo: right, constant: -rightConstant)
            constraint.identifier = "right"
            anchors.append(constraint)
        }
        
        if widthConstant > 0 {
            let constraint = widthAnchor.constraint(equalToConstant: widthConstant)
            constraint.identifier = "width"
            anchors.append(constraint)
        }
        
        if heightConstant > 0 {
            let constraint = heightAnchor.constraint(equalToConstant: heightConstant)
            constraint.identifier = "height"
            anchors.append(constraint)
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func removeAllConstraints() {
        var view: UIView? = self
        while let currentView = view {
            currentView.removeConstraints(currentView.constraints.filter {
                return $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
            })
            view = view?.superview
        }
    }
    
    func getDictionaryOfVariableBindings(viewArray : [UIView]) -> NSDictionary{
        
        let dicView : NSMutableDictionary = NSMutableDictionary()
        
        for view in viewArray{
            if let viewName = view.layer .value(forKey: ControlConstant.name) as? String{
                dicView .setValue(view, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    func setBorder(_ borderColor: UIColor, width: CGFloat, radius: CGFloat){
        
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        
    }
    
    func setTopBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "upper_layer"
        var upperBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                upperBorder = layer
                break
            }
        }
        
        if(upperBorder == nil){
            upperBorder = CALayer()
        }
        
        upperBorder!.name = layerName
        upperBorder!.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0)
        
        upperBorder!.borderWidth = width
        upperBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(upperBorder!)
    }
    
    func setBottomBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "bottom_layer"
        var bottomBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                bottomBorder = layer
                break
            }
        }
        
        if(bottomBorder == nil){
            bottomBorder = CALayer()
        }
        
        bottomBorder!.name = layerName
        bottomBorder!.frame = CGRect(x: 0, y: self.frame.height - width, width: self.frame.width, height: width)
        
        bottomBorder!.borderWidth = width
        bottomBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(bottomBorder!)
        
    }
    
    func setLeftBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "left_layer"
        var leftBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                leftBorder = layer
                break
            }
        }
        
        if(leftBorder == nil){
            leftBorder = CALayer()
        }
        
        leftBorder!.name = layerName
        leftBorder!.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
        
        leftBorder!.borderWidth = width
        leftBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(leftBorder!)
    }
    
    func setRightBorder(_ borderColor: UIColor, width: CGFloat) {
        
        let layerName: String = "right_layer"
        var rightBorder: CALayer?
        
        for layer: CALayer in self.layer.sublayers!{
            if layer.name == layerName {
                rightBorder = layer
                break
            }
        }
        
        if(rightBorder == nil){
            rightBorder = CALayer()
        }
        
        rightBorder!.name = layerName
        rightBorder!.frame = CGRect(x: 0, y: self.frame.width, width: width, height: self.frame.height)
        
        rightBorder!.borderWidth = width
        rightBorder!.borderColor = borderColor.cgColor
        
        self.layer.addSublayer(rightBorder!)
    }
    
    //    container.addBorder(edges: [.all]) // All with default arguments
    //    container.addBorder(edges: [.top], color: UIColor.greenColor()) // Just Top, green, default thickness
    //    container.addBorder(edges: [.left, .right, .bottom], color: UIColor.redColor(), thickness: 3) // All except Top, red, thickness 3
    func addBorder(edges: UIRectEdge, color: UIColor = UIColor.white, thickness: CGFloat = 1.0) -> [UIView] {
        
        var borders = [UIView]()
        
        func border() -> UIView {
            let border = UIView(frame: CGRect.zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["top": top]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["top": top]))
            borders.append(top)
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["left": left]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["left": left]))
            borders.append(left)
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["right": right]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["right": right]))
            borders.append(right)
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                               options: [],
                                               metrics: ["thickness": thickness],
                                               views: ["bottom": bottom]))
            addConstraints(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                               options: [],
                                               metrics: nil,
                                               views: ["bottom": bottom]))
            borders.append(bottom)
        }
        
        return borders
    }
    
    
    func setCircleViewWith(_ borderColor: UIColor, width: CGFloat) {
        
        self.layer.cornerRadius = (self.frame.size.width / 2)
        self.layer.masksToBounds = (true)
        self.layer.borderWidth = (width)
        self.layer.borderColor = (borderColor.cgColor)
        
        let containerLayer: CALayer = CALayer()
        containerLayer.shadowColor = UIColor.black.cgColor
        
        containerLayer.shadowRadius = 10.0
        containerLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        containerLayer.shadowOpacity = 1.0
        self.superview?.layer.addSublayer(containerLayer)
        
    }
    
    func removeIndicatorFromView() {
        
        let layerNamebox: String = "bottom_box_layer"
        let layerNamepoint: String = "bottom_point_layer"
        
        for layer in self.layer.sublayers! {
            if layer.name == layerNamebox {
                layer.removeFromSuperlayer()
                break
            }
        }
        
        for layer in self.layer.sublayers! {
            if layer.name == layerNamepoint {
                layer.removeFromSuperlayer()
                break
            }
        }
        
    }
    
    func getViewControllerFromSubView() -> UIViewController? {
        
        var responder: UIResponder = self
        responder = responder.next!
        
        while !(responder.isKind(of: NSNull.self)) {
            if responder.isKind(of: UIViewController.self) {
                return responder as? UIViewController
            }
            responder = responder.next!
        }
        
        return nil
    }
    //  Get End X point of view
    var endX : CGFloat {
        return frame.origin.x + frame.width
    }
    
    //  Get End Y point of view
    var endY : CGFloat {
        return frame.origin.y + frame.height
    }
   
    //  Get Parent View controller
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController?
            }
        }
        return nil
    }
    
    //  Apply plain shadow to view
    func applyPlainShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
    }
    
    //  Apply boarder to view
    func applyBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Apply corner radius
    func applyCornerRadius(_ corenrRadius : CGFloat , mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = corenrRadius
    }
    
    //  Add only bottom border
    func applyBottomBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Add Top Border
    func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.width, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Right Border
    func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.width - width, y: 0, width: width, height: self.height)
        self.layer.addSublayer(border)
    }
    
    //  Add Bottom Border
    func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.height - width, width: self.width, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Left Border
    func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.height)
        self.layer.addSublayer(border)
    }
    
    
    // TODO: Autolayout Constraint
    func topEqualTo(view : UIView) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    func topSpaceToSuper(space : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    func topSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    func bottomEqualTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    func bottomSpaceToSuper(spcae : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1.0, constant: spcae))
    }
    
    func bottomSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    func leftMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
    }
    
    func leftMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: margin))
    }
    
    func rightMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
    }
    
    func rightMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: margin))
    }
    
    func horizontalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: space))
    }
    
    func verticalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    func edgeEqualTo(view : UIView){
        self.leftMarginTo(view: view)
        self.rightMarginTo(view: view)
        self.topEqualTo(view: view)
        self.bottomEqualTo(view: view)
    }
    
    func edgeToSuperView(top : CGFloat,left : CGFloat,bottom : CGFloat,right : CGFloat){
        self.topSpaceTo(view: self.superview!, space: top)
        self.bottomSpaceToSuper(spcae: bottom)
        self.leftMarginTo(view: self.superview!, margin: left)
        self.rightMarginTo(view: self.superview!, margin: right)
    }
    
    func verticalSpace(Views : [UIView],space : CGFloat) -> Void{
        
        var verticalString : String = ""
        
        for (index,view) in Views.enumerated(){
            if index == 0{
                verticalString = "[\(view.layer .value(forKey: ControlConstant.name) as! String)]"
            }
            else{
                verticalString = verticalString + "\(space)" + "[\(view.layer .value(forKey: ControlConstant.name) as! String)]"
            }
        }
        
        var viewDic : NSDictionary! = self.getDictionaryOfVariableBindings(viewArray: Views)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:\(verticalString)", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
        viewDic = nil
    }
    
    func horizontalSpace(Views : [UIView],space : CGFloat) -> Void{
        var horizontalSpace : String = ""
        
        for (index,view) in Views.enumerated(){
            if index == 0{
                horizontalSpace = "[\(view.layer .value(forKey: ControlConstant.name) as! String)]"
            }
            else{
                horizontalSpace = horizontalSpace + "\(space)" + "[\(view.layer .value(forKey: ControlConstant.name) as! String)]"
            }
        }
        
        var viewDic : NSDictionary! = self.getDictionaryOfVariableBindings(viewArray: Views)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:\(horizontalSpace)", options: NSLayoutConstraint.FormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
        viewDic = nil
    }
    
    // MARK: - Enums -
    
    /**
     Direction of flip animation
     
     - FromTop:    Flip animation from top
     - FromLeft:   Flip animation from left
     - FromRight:  Flip animation from right
     - FromBottom: Flip animation from bottom
     */
    enum UIViewAnimationFlipDirection : Int {
        case FromTop
        case FromLeft
        case FromRight
        case FromBottom
    }
    
    /**
     Direction of the translation
     
     - FromLeftToRight: Translation from left to right
     - FromRightToLeft: Translation from right to left
     */
    enum UIViewAnimationTranslationDirection : Int {
        case FromLeftToRight
        case FromRightToLeft
    }
    
    /**
     Direction of the linear gradient
     
     - Vertical:                            Linear gradient vertical
     - Horizontal:                          Linear gradient horizontal
     - DiagonalFromLeftToRightAndTopToDown: Linear gradient from left to right and top to down
     - DiagonalFromLeftToRightAndDownToTop: Linear gradient from left to right and down to top
     - DiagonalFromRightToLeftAndTopToDown: Linear gradient from right to left and top to down
     - DiagonalFromRightToLeftAndDownToTop: Linear gradient from right to left and down to top
     */
    enum UIViewLinearGradientDirection : Int {
        case Vertical
        case Horizontal
        case DiagonalFromLeftToRightAndTopToDown
        case DiagonalFromLeftToRightAndDownToTop
        case DiagonalFromRightToLeftAndTopToDown
        case DiagonalFromRightToLeftAndDownToTop
    }
    
    // MARK: - Instance functions -
    
    /**
     Create a border around the UIView
     
     - parameter color:  Border's color
     - parameter radius: Border's radius
     - parameter width:  Border's width
     */
    func createBordersWithColor(color: UIColor, radius: CGFloat, width: CGFloat) {
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = 2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        let cgColor: CGColor = color.cgColor
        self.layer.borderColor = cgColor
    }
    
    /**
     Remove the borders around the UIView
     */
    func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.borderColor = nil
    }
    
    /**
     Remove the shadow around the UIView
     */
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        
    }
    
    /**
     Set the corner radius of UIView
     
     - parameter radius: Radius value
     */
    func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /**
     Set the corner radius of UIView only at the given corner
     
     - parameter corners: Corners to apply radius
     - parameter radius: Radius value
     */
    func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.frame
        rectShape.position = self.center
        rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
        self.layer.mask = rectShape
    }
    
    /**
     Create a shadow on the UIView
     
     - parameter offset:  Shadow's offset
     - parameter opacity: Shadow's opacity
     - parameter radius:  Shadow's radius
     */
    func createRectShadowWithOffset(offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.masksToBounds = false
    }
    
    /**
     Create a corner radius shadow on the UIView
     
     - parameter cornerRadius: Corner radius value
     - parameter offset:       Shadow's offset
     - parameter opacity:      Shadow's opacity
     - parameter radius:       Shadow's radius
     */
    func createCornerRadiusShadowWithCornerRadius(cornerRadius: CGFloat, offset: CGSize, opacity: Float, radius: CGFloat) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shouldRasterize = true
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        self.layer.masksToBounds = false
    }
    
    /**
     Create a linear gradient
     
     - parameter colors:    Array of UIColor instances
     - parameter direction: Direction of the gradient
     */
    func createGradientWithColors(colors: Array<UIColor>, direction: UIViewLinearGradientDirection) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        
        let mutableColors: NSMutableArray = NSMutableArray(array: colors)
        for i in 0 ..< colors.count {
            let currentColor: UIColor = colors[i]
            mutableColors.replaceObject(at: i, with: currentColor.cgColor)
        }
        gradient.colors = mutableColors as AnyObject as! Array<UIColor>
        
        switch direction {
        case .Vertical:
            gradient.startPoint = CGPoint.init(x: 0.5, y: 0.0)
            gradient.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        case .Horizontal:
            gradient.startPoint = CGPoint.init(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        case .DiagonalFromLeftToRightAndTopToDown:
            gradient.startPoint = CGPoint.init(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint.init(x: 1.0, y: 1.0)
        case .DiagonalFromLeftToRightAndDownToTop:
            gradient.startPoint = CGPoint.init(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint.init(x: 1.0, y: 0.0)
        case .DiagonalFromRightToLeftAndTopToDown:
            gradient.startPoint = CGPoint.init(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint.init(x: 0.0, y: 1.0)
        case .DiagonalFromRightToLeftAndDownToTop:
            gradient.startPoint = CGPoint.init(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint.init(x: 0.0, y: 0.0)
        }
        self.layer.insertSublayer(gradient, at:0)
    }
    
    /**
     Create a shake effect on the UIView
     */
    func shakeView() {
        let shake: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [NSValue(caTransform3D: CATransform3DMakeTranslation(-5.0, 0.0, 0.0)), NSValue(caTransform3D: CATransform3DMakeTranslation(5.0, 0.0, 0.0))]
        shake.autoreverses = true
        shake.repeatCount = 2.0
        shake.duration = 0.07
        
        self.layer.add(shake, forKey:"shake")
    }
    
    /**
     Create a pulse effect on th UIView
     
     - parameter duration: Seconds of animation
     */
    func pulseViewWithDuration(duration: CGFloat) {
        UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { (finished) -> Void in
            if finished {
                UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
                    self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
                }) { (finished: Bool) -> Void in
                    if finished {
                        UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
                            self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
                        }) { (finished: Bool) -> Void in
                            if finished {
                                UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
                                    self.transform = CGAffineTransform(scaleX: 0.985, y: 0.985)
                                }) { (finished: Bool) -> Void in
                                    if finished {
                                        UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
                                            self.transform = CGAffineTransform(scaleX: 1.007, y: 1.007)
                                        }) { (finished: Bool) -> Void in
                                            if finished {
                                                UIView.animate(withDuration: TimeInterval(duration / 6), animations: { () -> Void in
                                                    self.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                })
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
   
    /**
     Adds a motion effect to the view
     */
    func applyMotionEffects() {
        let horizontalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontalEffect.minimumRelativeValue = -10.0
        horizontalEffect.maximumRelativeValue = 10.0
        let verticalEffect: UIInterpolatingMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        verticalEffect.minimumRelativeValue = -10.0
        verticalEffect.maximumRelativeValue = 10.0
        let motionEffectGroup: UIMotionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [horizontalEffect, verticalEffect]
        
        self.addMotionEffect(motionEffectGroup)
    }
    
    /**
     Flip the view
     
     - parameter duration:  Seconds of animation
     - parameter direction: Direction of the flip animation
     */
    func flipWithDuration(duration: TimeInterval, direction: UIViewAnimationFlipDirection) {
        var subtype: String = ""
        
        switch(direction) {
        case .FromTop:
            subtype = "fromTop"
        case .FromLeft:
            subtype = "fromLeft"
        case .FromBottom:
            subtype = "fromBottom"
        case .FromRight:
            subtype = "fromRight"
        }
        
        let transition: CATransition = CATransition()
        
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = CATransitionType(rawValue: "flip")
        transition.subtype = CATransitionSubtype(rawValue: subtype)
        transition.duration = duration
        transition.repeatCount = 1
        transition.autoreverses = true
        
        self.layer.add(transition, forKey:"flip")
    }
    
    /**
     Translate the UIView around the topView
     
     - parameter topView:         Top view to translate to
     - parameter duration:        Duration of the translation
     - parameter direction:       Direction of the translation
     - parameter repeatAnimation: If the animation must be repeat or no
     - parameter startFromEdge:   If the animation must start from the edge
     */
    func translateAroundTheView(topView: UIView, duration: CGFloat, direction: UIViewAnimationTranslationDirection, repeatAnimation: Bool = true, startFromEdge: Bool = true) {
        var startPosition: CGFloat = self.center.x, endPosition: CGFloat
        switch(direction) {
        case .FromLeftToRight:
            startPosition = self.frame.size.width / 2
            endPosition = -(self.frame.size.width / 2) + topView.frame.size.width
        case .FromRightToLeft:
            startPosition = -(self.frame.size.width / 2) + topView.frame.size.width
            endPosition = self.frame.size.width / 2
        }
        
        if startFromEdge {
            self.center = CGPoint.init(x: startPosition, y: self.center.y)
        }
        
        UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: .curveEaseInOut, animations: { () -> Void in
            self.center = CGPoint.init(x: endPosition, y: self.center.y)
        }) { (finished: Bool) -> Void in
            if finished {
                UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: .curveEaseInOut, animations: { () -> Void in
                    self.center =  CGPoint.init(x: startPosition, y: self.center.y)
                }) { (finished: Bool) -> Void in
                    if finished {
                        if repeatAnimation {
                            self.translateAroundTheView(topView: topView, duration: duration, direction: direction, repeatAnimation: repeatAnimation, startFromEdge: startFromEdge)
                        }
                    }
                }
            }
        }
    }
    
    /**
     Take a screenshot of the current view
     
     - returns: Returns screenshot as UIImage
     */
    func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let imageData: NSData = image.pngData()! as NSData
        image = UIImage(data: imageData as Data)!
        
        return image
    }
    
    /**
     Take a screenshot of the current view an saving to the saved photos album
     
     - returns: Returns screenshot as UIImage
     */
    func saveScreenshot() -> UIImage {
        let image: UIImage = self.screenshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        return image
    }
    
    /**
     Removes all subviews from current view
     */
    func removeAllSubviews() {
        self.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
    }
    
}
