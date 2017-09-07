//
//  SideMenuView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 06/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SwiftyBase
import UIKit

class SideMenuView: BaseView {
    
    // MARK: - Attribute -
    internal var userProfileView : UIView!
    private var imgUser : BaseImageView!
    var lblUserRealName : BaseLabel!
    var lblUserName: BaseLabel!
    
    private var seperatorView : UIView!
    private var tblMenu : UITableView!
    private var btnlogin : BaseButton!
    
    internal var arrMenuData : NSMutableArray! = NSMutableArray()
    internal var selectedCell : IndexPath = IndexPath(item: 0, section: 0)
    internal var selectedMenu : Int = Menu.api.rawValue
    
    fileprivate var cellSelecteEvent : TableCellSelectEvent!
    
    // MARK: - Lifecycle -
    init(){
        super.init(frame: .zero)
        self.loadViewControls()
        self.setViewlayout()
        self.loadMenuData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imgUser != nil{
            imgUser.clipsToBounds = true
            imgUser.layer.cornerRadius = imgUser.frame.size.width / 2
        }
    }
    
    deinit{
        print("side menu deinit called")
        self.releaseObject()
    }
    
    override func releaseObject() {
        super.releaseObject()
        
        
    }
    
    // MARK: - Layout -
    override func loadViewControls()
    {
        super.loadViewControls()
        
        self.backgroundColor = Color.appPrimaryBG.value
        
        userProfileView = UIView()
        userProfileView.layer .setValue("userProfileView", forKey: ControlConstant.name)
        userProfileView.translatesAutoresizingMaskIntoConstraints = false
        userProfileView.backgroundColor = UIColor.clear
        self.addSubview(userProfileView)
        
        btnlogin = BaseButton(ibuttonType: .transparent, iSuperView: userProfileView)
        btnlogin.backgroundColor = UIColor.clear
        btnlogin.isHidden = false
        
        btnlogin.setButtonTouchUpInsideEvent { [weak self] (sendor, object) in
            if self == nil{
                return
            }
            if self!.cellSelecteEvent != nil{
                self!.cellSelecteEvent(nil,Menu.api.rawValue as AnyObject)
            }
        }
        
        imgUser = BaseImageView(type: .defaultImg, superView: userProfileView)
        imgUser.layer .setValue("imgUser", forKey: ControlConstant.name)
        imgUser.backgroundColor = UIColor.white
        imgUser.isHidden = true
        
        seperatorView = UIView()
        seperatorView.layer .setValue("seperatorView", forKey: ControlConstant.name)
        seperatorView.backgroundColor = Color.appSecondaryBG.value
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(seperatorView)
        
        lblUserName = BaseLabel(labelType: .small, superView: userProfileView)
        lblUserName.layer .setValue("lblUserName", forKey: ControlConstant.name)
        lblUserName.text = ""
        lblUserName.textColor = Color.appSecondaryBG.value
        lblUserName.isHidden = true
        lblUserName.textAlignment = .left
        
        lblUserRealName = BaseLabel(labelType: .large, superView: userProfileView)
        lblUserRealName.layer .setValue("lblUserRealName", forKey: ControlConstant.name)
        lblUserRealName.text = ""
        lblUserRealName.textColor = Color.appSecondaryBG.value
        lblUserRealName.isHidden = true
        
        tblMenu = UITableView(frame: .zero, style: .grouped)
        tblMenu.layer .setValue("tblMenu", forKey: ControlConstant.name)
        tblMenu.translatesAutoresizingMaskIntoConstraints = false
        tblMenu.backgroundColor = UIColor.clear
        tblMenu.separatorStyle = .none
        tblMenu.cellLayoutMarginsFollowReadableWidth = false
        tblMenu.alwaysBounceVertical = false
        tblMenu.delegate = self
        tblMenu.dataSource = self
        tblMenu.tableFooterView = UIView(frame: .zero)
        tblMenu.register(LeftMenuCell.self, forCellReuseIdentifier: CellIdentifire.leftMenu)
        self.addSubview(tblMenu)
    
        
    }
    
    override func setViewlayout() {
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        baseLayout.metrics = ["hSpace" : ControlConstant.horizontalPadding, "vSpace" : ControlConstant.verticalPadding / 2]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[userProfileView]|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[userProfileView]-[seperatorView(==1)][tblMenu]|", options: [.alignAllLeading,.alignAllTrailing], metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        baseLayout.expandView(btnlogin, insideView: userProfileView)
        
        // UserProfile View Constraint
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-vSpace-[imgUser]-vSpace-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hSpace-[imgUser]-hSpace-[lblUserName]-hSpace-|", options: NSLayoutFormatOptions(rawValue : 0), metrics: baseLayout.metrics, views: baseLayout.viewDictionary)
        
        userProfileView.addConstraints(baseLayout.control_H)
        userProfileView.addConstraints(baseLayout.control_V)
        
        lblUserRealName.bottomAnchor.constraint(equalTo: imgUser.centerYAnchor, constant: ControlConstant.verticalPadding / 2).isActive = true
        lblUserName.topAnchor.constraint(equalTo: imgUser.centerYAnchor, constant: ControlConstant.verticalPadding / 2).isActive = true
        
        lblUserRealName.leadingAnchor.constraint(equalTo: lblUserName.leadingAnchor).isActive = true
        lblUserRealName.trailingAnchor.constraint(equalTo: lblUserName.trailingAnchor).isActive = true
        imgUser.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width * 0.20).isActive = true
        imgUser.heightAnchor.constraint(equalTo: imgUser.widthAnchor).isActive = true
        
        
        self.layoutIfNeeded()
        self.layoutSubviews()
    }
    
    // MARK: - Public Interface -
    open func updateUI(){
        //        imgUser.layer.cornerRadius = (UIScreen.main.bounds.size.width * 0.15) / 2
        //        imgUser.clipsToBounds = true
    }
    
    open func cellSelectedEvent( event : @escaping TableCellSelectEvent) -> Void{
        cellSelecteEvent = event
    }
    
    open func setSelectedMenu(type : Int) -> Void{
        
        selectedCell = IndexPath.init()
        
        for (section,item) in arrMenuData.enumerated(){
            for (index,menu) in ((item as! NSDictionary)["item"] as! NSArray).enumerated(){
                if (menu as! NSDictionary)["type"] as! Int == type{
                    selectedCell = IndexPath(row: index, section: section)
                }
            }
        }
        
        tblMenu.reloadData()
    }
    
    
    
    open func showLoginView(){
        self.btnlogin.isHidden = false
        self.imgUser.isHidden = false
        self.lblUserName.isHidden = false
        self.lblUserRealName.isHidden = false
        self.imgUser.image = UIImage(named: "App_icon")!
        self.lblUserName.text = "Login with Instagram"
        self.lblUserRealName.text = "LargeDp"
        
    }
    
    open func showProfileView(){
        self.btnlogin.isHidden = true
        self.imgUser.isHidden = false
        self.lblUserName.isHidden = false
        self.lblUserRealName.isHidden = false
    }
    
    open func loadMenuData(){
        
        arrMenuData.removeAllObjects()
        
        for menuData in AppPlistManager().readFromPlist("Menu") as! NSMutableArray
        {
            let dicMenu : NSMutableDictionary = menuData as! NSMutableDictionary
            var arrItem : [NSDictionary] = []
            for item in dicMenu["item"] as! NSArray
            {
                arrItem.append(item as! NSDictionary)
                
            }
            dicMenu .setObject(arrItem, forKey: "item" as NSCopying)
            arrMenuData.add(dicMenu)
        }
        tblMenu.reloadData()
    }
    
    // MARK: - User Interaction -
    
    
    // MARK: - Internal Helpers -
    
    
    fileprivate func getDataForCell(indexPath : IndexPath) -> NSDictionary{
        var dicMenu : NSDictionary! = arrMenuData[indexPath.section] as! NSDictionary
        var arrItem : NSArray! = dicMenu["item"] as! NSArray
        
        defer {
            dicMenu = nil
            arrItem = nil
        }
        return arrItem[indexPath.row] as! NSDictionary
    }
    
    // MARK: - Delegate Method -
    
    // MARK: - Server Request -
    
}

// MARK : Extension
// TODO : UITableView Delegate
extension SideMenuView : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData : NSDictionary = self.getDataForCell(indexPath: indexPath)
        
        if self.cellSelecteEvent != nil{
            self.cellSelecteEvent(nil,cellData["type"] as AnyObject)
        }
    }
}

// TODO : UITableView DataSource
extension SideMenuView : UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrMenuData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dicMenu : NSDictionary = arrMenuData[section] as! NSDictionary
        let arrItem : NSArray = dicMenu["item"] as! NSArray
        return arrItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell : LeftMenuCell!
        cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.leftMenu) as? LeftMenuCell
        
        if cell == nil
        {
            cell = LeftMenuCell(style: UITableViewCellStyle.default, reuseIdentifier: CellIdentifire.leftMenu)
        }
        
        let cellData : NSDictionary = self.getDataForCell(indexPath: indexPath)
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
       
        if indexPath == selectedCell
        {
            cell.lblMenuText.textColor = Color.navigationBottomBorder.value
            if let image = UIImage(named: cellData["icon"] as! String) {
                cell.imgIcon.image = image.maskWithColor(Color.navigationBottomBorder.value)
                cell.backgroundColor = Color.navigationTitle.value
            }
        }
        else
        {
            cell.lblMenuText?.textColor = Color.navigationBottomBorder.value
            if let image = UIImage(named: cellData["icon"] as! String) {
                cell.imgIcon.image = image.maskWithColor(Color.navigationBottomBorder.value)
                cell.backgroundColor = UIColor.clear
            }
        }
        
        cell.lblMenuText?.text = (cellData["title"] as? String)?.localize()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        
        let lbltext : UILabel = UILabel(frame: CGRect(x: 10, y:5, width: headerView.bounds.size.width, height: 20))
        
        lbltext.textColor = Color.navigationBottomBorder.value
        lbltext.text = ((arrMenuData[section] as! NSDictionary)["title"] as? String)?.localize()
        headerView.addSubview(lbltext)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
}
