//
//  APIDemoView.swift
//  SwiftyBase
//
//  Created by MacMini-2 on 05/09/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#if os(macOS)
    import Cocoa
#else
    import UIKit
#endif
import SwiftyBase

class APIDemoView: BaseView,UITableViewDataSource, UITableViewDelegate {
   
    // MARK: - Attributes -
    
    var listTableView : UITableView!
    var countrylist : AllContry!
    
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
        listTableView = nil
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
        listTableView = UITableView(frame: CGRect.zero, style: .plain)
        listTableView.translatesAutoresizingMaskIntoConstraints = false
        
        //must required for self.getDictionaryOfVariableBindings funcation Used
        listTableView.layer.setValue("listTableView", forKey: ControlConstant.name)
        
        listTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifire.defaultCell)
        
        listTableView.backgroundColor = UIColor.clear
        listTableView.separatorStyle = .singleLine
        
        listTableView.separatorColor = Color.buttonSecondaryBG.value
        
        listTableView.clipsToBounds = true
        
        listTableView.tableHeaderView = UIView(frame: CGRect.zero)
        listTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        listTableView.rowHeight = UITableViewAutomaticDimension
        self.addSubview(listTableView)
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as! [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[listTableView]|", options:NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[listTableView]|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
        
        self.layoutSubviews()
        
    }
    
    
    // MARK: - Public Interface -
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    
    // MARK: - Server Request -
    
    func getListServerRequest(){

        self.isShowEmptyView(true,message: "API Call Running...")
        APIManager.shared.getRequest(URL: API.countries, Parameter: NSDictionary(), completionHandler:{(result) in
            
            switch result{
            case .Success(let object, _):
                self.isShowEmptyView(false,message: "API Call Running...")
                AppUtility.executeTaskInMainQueueWithCompletion {
                    self.hideToastActivity()
                    BaseProgressHUD.shared.hide()
                }
                self.makeToast(message: "Success")
                
                let jsonData = (object as! String).parseJSONString
                
                self.countrylist = AllContry.init(fromDictionary: jsonData as! [String : Any])
              
                AppUtility.executeTaskInMainQueueWithCompletion {
                     self.listTableView.reloadWithAnimation()
                }
                
                break
            case .Error(let error):
                
                AppUtility.executeTaskInMainQueueWithCompletion {
                    self.hideToastActivity()
                    BaseProgressHUD.shared.hide()
                }
                
                print(error ?? "")
                
                break
            case .Internet(let isOn):
                print("Internet is  \(isOn)")
                
                self.handleNetworkCheck(isAvailable: isOn, viewController: self, showLoaddingView: true)
                break
            }
        })
    }
    
    // MARK: - UITableView DataSource Methods -
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if self.countrylist != nil{
            return self.countrylist.result.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifire.defaultCell) as UITableViewCell?
        
        if(cell == nil){
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: CellIdentifire.defaultCell)
        }
        let result : Result = self.countrylist.result[indexPath.row]
        cell?.textLabel?.text = result.name
        
        return cell!
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath){
        
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    
}
