//
//  ListView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 30/08/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import SwiftyBase

class ListView: BaseView,UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Attributes -
    
    var testView : UIView!
    
    var personListTableView : UITableView!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    deinit{
        personListTableView = nil
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
        testView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(UIScreen.main.bounds.width), height: 200))
        
        //testView.translatesAutoresizingMaskIntoConstraints = false
        testView.backgroundColor = UIColor.red
        testView.layer.setValue("testView", forKey: ControlConstant.name)
        self.addSubview(testView)
        
        
        personListTableView = UITableView(frame: CGRect.zero, style: .grouped)
        personListTableView.translatesAutoresizingMaskIntoConstraints = false
        personListTableView.layer.setValue("personListTableView", forKey: ControlConstant.name)
        
        personListTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifire.defaultCell)
        
        personListTableView.backgroundColor = UIColor.clear
        personListTableView.separatorStyle = .singleLine
        
        personListTableView.separatorColor = Color.buttonSecondaryBG.value
        
        personListTableView.clipsToBounds = true
        
        personListTableView.tableHeaderView = UIView(frame: CGRect.zero)
        personListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        personListTableView.rowHeight = UITableViewAutomaticDimension
        self.addSubview(personListTableView)
        
        personListTableView.delegate = self
        personListTableView.dataSource = self
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlLayout.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlLayout.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[personListTableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-[testView]-[personListTableView]-|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        generateDiagonal(view: testView)
        
        self.layoutSubviews()
        
        
        
        // baseLayout.expandView(personListTableView, insideView: self)
        
    }
    
    func generateDiagonal(view: UIView?) {
        let maskLayer : CAShapeLayer = CAShapeLayer()
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.frame = (view?.bounds)!
        
        UIGraphicsBeginImageContext((view?.bounds.size)!);
        let path = UIBezierPath()
        
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint.init(x: (view?.bounds.size.width)!, y: 0))
        
        
        path.addLine(to: CGPoint.init(x: (view?.bounds.size.width)!, y: (view?.bounds.size.height)! / 2))
        
        path.addLine(to: CGPoint.init(x: 0, y: (view?.bounds.size.height)!))
        
        path.close()
        path.fill()
        
        maskLayer.path = path.cgPath;
        UIGraphicsEndImageContext();
        view!.layer.mask = maskLayer;
    }
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
    
    
    // MARK: - UITableView DataSource Methods -
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.defaultCell) as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifire.defaultCell)
        }
        
        return cell!
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 90.0
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
}
