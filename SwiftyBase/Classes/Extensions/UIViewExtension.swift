//
//  UIViewExtension.swift
//  Pods
//
//  Created by MacMini-2 on 30/08/17.
//
//

import Foundation

// MARK: - UIView Extension -

public extension UIView {
    
    var width:      CGFloat { return self.frame.size.width }
    var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    var x:          CGFloat { return self.frame.origin.x }
    var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    public func applyGradient(colours: [UIColor])  {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    public func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    public func hideShadow() {
        self.layer.shadowOpacity = 0
    }
    
    public func setSize(_ size:CGSize)
    {
        self.frame.size = size
    }
    
    public func setOrigin(_ point:CGPoint)
    {
        self.frame.origin = point
    }
    
    public func setX(_ x:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: x, y: self.frame.origin.y)
    }
    
    public func setY(_ y:CGFloat) //only change the origin x
    {
        self.frame.origin = CGPoint(x: self.frame.origin.x, y: y)
    }
    
    public func roundCorner(_ radius:CGFloat)
    {
        self.layer.cornerRadius = radius
    }
    
    public func setTop(_ top:CGFloat)
    {
        self.frame.origin.y = top
    }
    
    public func setLeft(_ left:CGFloat)
    {
        self.frame.origin.x = left
    }
    
    public func setRight(_ right:CGFloat)
    {
        self.frame.origin.x = right - self.frame.size.width
    }
    
    public func setBottom(_ bottom:CGFloat)
    {
        self.frame.origin.y = bottom - self.frame.size.height
    }
    
    public func isTextControl() -> Bool{
        return (self.isTextFieldControl() || self.isTextViewControl())
    }
    
    public func isTextFieldControl() -> Bool{
        return self.isKind(of: UITextField.self)
    }
    
    public func isTextViewControl() -> Bool{
        return self.isKind(of: UITextView.self)
    }
    
    public func getRequestDictionaryFromView() -> [String: String]{
        
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
    
    public func getDictionaryOfVariableBindings(superView : UIView , viewDic : NSDictionary) -> NSDictionary
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
    
    public func fillSuperview() {
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
    
    public func removeAllConstraints() {
        var view: UIView? = self
        while let currentView = view {
            currentView.removeConstraints(currentView.constraints.filter {
                return $0.firstItem as? UIView == self || $0.secondItem as? UIView == self
            })
            view = view?.superview
        }
    }
    
    public func getDictionaryOfVariableBindings(viewArray : [UIView]) -> NSDictionary{
        
        let dicView : NSMutableDictionary = NSMutableDictionary()
        
        for view in viewArray{
            if let viewName = view.layer .value(forKey: ControlConstant.name) as? String{
                dicView .setValue(view, forKey: viewName)
            }
        }
        
        return dicView
    }
    
    public func setBorder(_ borderColor: UIColor, width: CGFloat, radius: CGFloat){
        
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = radius
        
    }
    
    public func setTopBorder(_ borderColor: UIColor, width: CGFloat) {
        
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
    
    public func setBottomBorder(_ borderColor: UIColor, width: CGFloat) {
        
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
    
    public func setLeftBorder(_ borderColor: UIColor, width: CGFloat) {
        
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
    
    public func setRightBorder(_ borderColor: UIColor, width: CGFloat) {
        
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
    
    public func setCircleViewWith(_ borderColor: UIColor, width: CGFloat) {
        
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
    
    public func removeIndicatorFromView() {
        
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
    
    public func getViewControllerFromSubView() -> UIViewController? {
        
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
    public var endX : CGFloat {
        return frame.origin.x + frame.width
    }
    
    //  Get End Y point of view
    public var endY : CGFloat {
        return frame.origin.y + frame.height
    }
    
    //  Get Origin.x
    public var startX : CGFloat {
        return frame.origin.x
    }
    
    //  Get Origin.y
    public var startY : CGFloat {
        return frame.origin.y
    }
    
    //  Get width of View
    public var getWidth : CGFloat {
        return frame.width
    }
    
    //  Get height of view
    public var getHeight : CGFloat {
        return frame.height
    }
    
    //  Set Origin.x
    public func setStartX(_ x : CGFloat) {
        self.frame.origin.x = x
    }
    
    //  Set Origin.y
    public func setStartY( _ y : CGFloat) {
        self.frame.origin.y = y
    }
    
    //  Set view width
    public func setWidth(_ width : CGFloat) {
        self.frame.size = CGSize(width: width, height: self.getHeight)
    }
    
    //  Set view height
    public func setHeight( _ height : CGFloat) {
        self.frame.size = CGSize(width: self.getWidth, height: height)
    }
    
    //  Set Center
    public func setCenter(_ x : CGFloat, y : CGFloat) {
        self.center = CGPoint(x : x,y: y)
    }
    
    //  Get center
    public func getCenter() -> CGPoint {
        return self.center
    }
    
    // Set center.x
    public func setCenterX(_ x: CGFloat) {
        self.center = CGPoint(x: x, y: self.getCenterY())
    }
    
    //  Get center.x
    public func getCenterX() -> CGFloat {
        return self.center.x
    }
    
    //  Set center.y
    public func setCenterY(_ y : CGFloat)  {
        self.center = CGPoint(x : self.getCenterX(), y : y)
    }
    
    //  Get center.y
    public func getCenterY() -> CGFloat {
        return self.center.y
    }
    
    //  Get Parent View controller
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as! UIViewController!
            }
        }
        return nil
    }
    
    //  Apply plain shadow to view
    public func applyPlainShadow() {
        let layer = self.layer
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 1.0
    }
    
    //  Apply boarder to view
    public func applyBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Apply corner radius
    public func applyCornerRadius(_ corenrRadius : CGFloat , mask : Bool) {
        self.layer.masksToBounds = mask
        self.layer.cornerRadius = corenrRadius
    }
    
    //  Add only bottom border
    public func applyBottomBorder() {
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    //  Add Top Border
    public func addTopBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.getWidth, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Right Border
    public func addRightBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.getWidth - width, y: 0, width: width, height: self.getHeight)
        self.layer.addSublayer(border)
    }
    
    //  Add Bottom Border
    public func addBottomBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.getHeight - width, width: self.getWidth, height: width)
        self.layer.addSublayer(border)
    }
    
    //  Add Left Border
    public func addLeftBorderWithColor(_ color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.getHeight)
        self.layer.addSublayer(border)
    }
    
    
    // TODO: Autolayout Constraint
    public func topEqualTo(view : UIView) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    public func topSpaceToSuper(space : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: self.superview, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func topSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func bottomEqualTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0.0))
    }
    
    public func bottomSpaceToSuper(spcae : CGFloat) -> Void{
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: self.superview, attribute: .bottom, multiplier: 1.0, constant: spcae))
    }
    
    public func bottomSpaceTo(view : UIView,space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func leftMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: 0.0))
    }
    
    public func leftMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: margin))
    }
    
    public func rightMarginTo(view : UIView){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: 0.0))
    }
    
    public func rightMarginTo(view : UIView,margin : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1.0, constant: margin))
    }
    
    public func horizontalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1.0, constant: space))
    }
    
    public func verticalSpace(view : UIView, space : CGFloat){
        self.superview?.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: space))
    }
    
    public func edgeEqualTo(view : UIView){
        self.leftMarginTo(view: view)
        self.rightMarginTo(view: view)
        self.topEqualTo(view: view)
        self.bottomEqualTo(view: view)
    }
    
    public func edgeToSuperView(top : CGFloat,left : CGFloat,bottom : CGFloat,right : CGFloat){
        self.topSpaceTo(view: self.superview!, space: top)
        self.bottomSpaceToSuper(spcae: bottom)
        self.leftMarginTo(view: self.superview!, margin: left)
        self.rightMarginTo(view: self.superview!, margin: right)
    }
    
    public func verticalSpace(Views : [UIView],space : CGFloat) -> Void{
        
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
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:\(verticalString)", options: NSLayoutFormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
        viewDic = nil
    }
    
    public func horizontalSpace(Views : [UIView],space : CGFloat) -> Void{
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
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:\(horizontalSpace)", options: NSLayoutFormatOptions(rawValue : 0), metrics: nil, views: viewDic as! [String : Any]))
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
    public enum UIViewAnimationFlipDirection : Int {
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
    public enum UIViewAnimationTranslationDirection : Int {
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
    public enum UIViewLinearGradientDirection : Int {
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
    public func createBordersWithColor(color: UIColor, radius: CGFloat, width: CGFloat) {
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
    public func removeBorders() {
        self.layer.borderWidth = 0
        self.layer.cornerRadius = 0
        self.layer.borderColor = nil
    }
    
    /**
     Remove the shadow around the UIView
     */
    public func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize.init(width: 0.0, height: 0.0)
        
    }
    
    /**
     Set the corner radius of UIView
     
     - parameter radius: Radius value
     */
    public func setCornerRadius(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    /**
     Set the corner radius of UIView only at the given corner
     
     - parameter corners: Corners to apply radius
     - parameter radius: Radius value
     */
    public func cornerRadius(corners: UIRectCorner, radius: CGFloat) {
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
    public func createRectShadowWithOffset(offset: CGSize, opacity: Float, radius: CGFloat) {
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
    public func createCornerRadiusShadowWithCornerRadius(cornerRadius: CGFloat, offset: CGSize, opacity: Float, radius: CGFloat) {
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
    public func createGradientWithColors(colors: Array<UIColor>, direction: UIViewLinearGradientDirection) {
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
    public func shakeView() {
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
    public func pulseViewWithDuration(duration: CGFloat) {
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
     Create a heartbeat effect on the UIView
     
     - parameter duration: Seconds of animation
     */
    public func heartbeatViewWithDuration(duration: CGFloat) {
        let maxSize: CGFloat = 1.4, durationPerBeat: CGFloat = 0.5
        
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        let scale1: CATransform3D = CATransform3DMakeScale(0.8, 0.8, 1)
        let scale2: CATransform3D = CATransform3DMakeScale(maxSize, maxSize, 1)
        let scale3: CATransform3D = CATransform3DMakeScale(maxSize - 0.3, maxSize - 0.3, 1)
        let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
        
        let frameValues: Array = [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)]
        
        animation.values = frameValues
        
        let frameTimes: Array = [NSNumber(value: 0.05), NSNumber(value: 0.2), NSNumber(value: 0.6), NSNumber(value: 1.0)]
        animation.keyTimes = frameTimes
        
        animation.fillMode = kCAFillModeForwards
        animation.duration = TimeInterval(durationPerBeat)
        animation.repeatCount = Float(duration / durationPerBeat)
        
        self.layer.add(animation, forKey: "heartbeat")
    }
    
    /**
     Adds a motion effect to the view
     */
    public func applyMotionEffects() {
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
    public func flipWithDuration(duration: TimeInterval, direction: UIViewAnimationFlipDirection) {
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
        transition.type = "flip"
        transition.subtype = subtype
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
    public func translateAroundTheView(topView: UIView, duration: CGFloat, direction: UIViewAnimationTranslationDirection, repeatAnimation: Bool = true, startFromEdge: Bool = true) {
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
    public func screenshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        image = UIImage(data: imageData as Data)!
        
        return image
    }
    
    /**
     Take a screenshot of the current view an saving to the saved photos album
     
     - returns: Returns screenshot as UIImage
     */
    public func saveScreenshot() -> UIImage {
        let image: UIImage = self.screenshot()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        return image
    }
    
    /**
     Removes all subviews from current view
     */
    public func removeAllSubviews() {
        self.subviews.forEach { (subview) -> () in
            subview.removeFromSuperview()
        }
    }
    
}
