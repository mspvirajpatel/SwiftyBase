//
//  ListView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 30/08/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import SwiftyBase

public enum PageView : Int {
    case unknown = -1
    case Button = 0
    case APICall = 1
    case Plist = 2
    static let allValues = [unknown, Button, APICall, Plist]
}

class ListView: BaseView,UITableViewDataSource, UITableViewDelegate{
    
    // MARK: - Attributes -
    
    var listControls : NSArray = ["Base Controls","API Call","Plist Read"]
 
    var imgView : BaseImageView!
    
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
        
        imgView = BaseImageView(type: .profile, superView: self)
        imgView.backgroundColor = UIColor.clear
        imgView.layer.setValue("imgView", forKey: ControlConstant.name)
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.setImageURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg")
        
        //For Full Screen Image Show
        imgView.setupForImageViewer()
        
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
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgView(120)][personListTableView]|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
      
        self.layoutSubviews()
        
    }
    
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
    
    // MARK: - UITableView DataSource Methods -
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
      
        return self.listControls.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.defaultCell) as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifire.defaultCell)
        }
        
        let result = self.listControls[indexPath.row]
        cell?.textLabel?.text = (result as! String)
       
        
        return cell!
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case PageView.Button.rawValue :
            
            Utility.setMenuViewType(Menu.button)
            
            break
            
        case PageView.APICall.rawValue :
           
            Utility.setMenuViewType(Menu.api)
            
            break
            
        case PageView.Plist.rawValue :
           
            if let controller : ListController = self.getViewControllerFromSubView() as? ListController
            {
                controller.openslider()
            }
            
            break
            
        default:
            break
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
}
