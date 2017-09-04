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
    
    var personListTableView : UITableView!
    var imgView : BaseImageView!
    var btnPrimary : BaseButton!
    var btnSecondary : BaseButton!
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.loadViewControls()
        self.setViewlayout()
        self.getListServerRequest()
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
        
        imgView = BaseImageView(type: .profile, superView: self)
        imgView.backgroundColor = UIColor.clear
        imgView.layer.setValue("imgView", forKey: ControlConstant.name)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.setImageURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg")
        
        //For Full Screen Image Show
        imgView.setupForImageViewer()
        
        btnPrimary = BaseButton.init(ibuttonType: .primary, iSuperView: self)
        btnPrimary.layer.setValue("btnPrimary", forKey: ControlConstant.name)
        btnPrimary.setTitle("Primary Button", for: UIControlState())
        
        btnSecondary = BaseButton.init(ibuttonType: .secondary, iSuperView: self)
        btnSecondary.layer.setValue("btnSecondary", forKey: ControlConstant.name)
        btnSecondary.setTitle("Secondary Button", for: UIControlState())

        personListTableView = UITableView(frame: CGRect.zero, style: .plain)
        personListTableView.translatesAutoresizingMaskIntoConstraints = false
        
        //must required for self.getDictionaryOfVariableBindings funcation Used
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
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[personListTableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgView(180)][btnPrimary][btnSecondary][personListTableView]|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
      
        self.layoutSubviews()
        
    }
    
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
    func getListServerRequest(){
        APIManager.shared.getRequest(URL: API.countries, Parameter: NSDictionary(), completionHandler:{(result) in
            
            switch result{
            case .Success(let object, _):
                
                print("API Get DATA - \(object!)")
                
                break
            case .Error(let error):
                
                print(error ?? "")
                
                break
            case .Internet(let isOn):
                print("Internet is  \(isOn)")
                break
            }
        })
    }
    
    
    // MARK: - UITableView DataSource Methods -
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      
        return 25
        
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
