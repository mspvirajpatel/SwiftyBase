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
    case Country = 3
    case Download = 4
    case ChangeLang = 5
    case Search = 6
    case SnapchatScrollView = 7
    case ImageView = 8
    static let allValues = [unknown, Button, APICall, Plist, Country, Download, ChangeLang,Search,SnapchatScrollView,ImageView]
}

class ListView: BaseView,UITableViewDataSource, UITableViewDelegate, BaseSearchDelegate{
    
    // MARK: - Attributes -
    
    var listControls : NSArray = ["lstBase","lstAPI","lstPlist","lstCountry","lstDownload","lstLanguage","Search View","Snapchat Scroll View","ImageView"]
 
    var imgView : BaseImageView!
    
    var personListTableView : UITableView!

    lazy var search: BaseSearchView = {
        let se = BaseSearchView.init(frame: UIScreen.main.bounds)
        se.delegate = self
        return se
    }()
    
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
        
        personListTableView.separatorColor = AppColor.buttonSecondaryBG.value
        
        personListTableView.clipsToBounds = true
        
        personListTableView.tableHeaderView = UIView(frame: CGRect.zero)
        personListTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        personListTableView.rowHeight = UITableView.automaticDimension
        self.addSubview(personListTableView)
        
        personListTableView.delegate = self
        personListTableView.dataSource = self
       
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        
        baseLayout.viewDictionary = self.getDictionaryOfVariableBindings(superView: self, viewDic: NSDictionary()) as? [String : AnyObject]
        
        let controlTopBottomPadding : CGFloat = ControlConstant.verticalPadding
        let controlLeftRightPadding : CGFloat = ControlConstant.horizontalPadding
        
        
        baseLayout.metrics = ["controlTopBottomPadding" : controlTopBottomPadding,
                              "controlLeftRightPadding" : controlLeftRightPadding
        ]
        
        baseLayout.control_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|[personListTableView]|", options:NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: baseLayout.viewDictionary)
        
        baseLayout.control_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|[imgView(150)][personListTableView]|", options:[.alignAllLeading , .alignAllTrailing], metrics: nil, views: baseLayout.viewDictionary)
        
        self.addConstraints(baseLayout.control_H)
        self.addConstraints(baseLayout.control_V)
      
        self.layoutSubviews()
        
    }
    
    
    // MARK: - Public Interface -
    func opensearch() {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.search)
            self.search.animate()
        }
    }
    
    func hideSearchView(status : Bool){
        if status == true {
            self.search.removeFromSuperview()
        }
    }
    
    // MARK: - User Interaction -
    
    // MARK: - Internal Helpers -
    public func animateTable() {
        self.personListTableView.reloadWithAnimation()
        
    }
    
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
        
        let result = (self.listControls[indexPath.row] as! String).localiz()
        cell?.textLabel?.text = result
       
        return cell!
    }
    
    // MARK: - UITableView Delegate Methods -
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableView.automaticDimension
        
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
        case PageView.Country.rawValue :
            
            /// Create a controller
            let countriesViewController = BaseCountriesPicker()
            
            /// Show major country
            countriesViewController.majorCountryLocaleIdentifiers = ["GB", "US", "IT", "DE", "RU", "BR", "IN"]
            
            /// Set initial selected
            //countriesViewController.selectedCountries = Countries.countriesFromCountryCodes(["AL"])
            
            /// Allow or disallow multiple selection
            countriesViewController.allowMultipleSelection = false
            
            /// Set delegate
            countriesViewController.delegate = self
            
            /// Show
            BaseCountriesPicker.show(countriesViewController: countriesViewController, to: self.getViewControllerFromSubView()!)
            
            break
        case PageView.Download.rawValue:
        
            self.getViewControllerFromSubView()?.navigationController?.pushViewController(DownloadingController(), animated: true)
            break
        case PageView.ChangeLang.rawValue:
            
            let selectedLanguage = AppLanguageManger.shared.currentLang == "en" ? "ar" : "en"
            AppLanguageManger.shared.setLanguage(language: selectedLanguage)
        
            self.animateTable()
            break
            
        case PageView.Search.rawValue:
            self.opensearch()
           
            break
           
        case PageView.SnapchatScrollView.rawValue:
            let left = UIViewController.init()
            left.view.backgroundColor = #colorLiteral(red: 0.5211794972, green: 0.7426617742, blue: 0, alpha: 1)
            let middle = UIViewController.init()
            middle.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            let right = UIViewController.init()
            right.view.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            let top = UIViewController.init()
            top.view.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            let bottom = UIViewController.init()
            bottom.view.backgroundColor = #colorLiteral(red: 1, green: 0.5746383667, blue: 0, alpha: 1)
            
            let container = BaseScrollViewController.containerViewWith(left,middleVC: middle,rightVC: right,topVC: top, bottomVC: bottom)
            
            container.maximumWidthFirstView = 200
            self.getViewControllerFromSubView()?.navigationController?.pushViewController(container, animated: true)
            
        case PageView.ImageView.rawValue:
            self.getViewControllerFromSubView()?.navigationController?.pushViewController(DisplayAllImageController(), animated: true)
            
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

extension ListView: BaseCountriesPickerDelegate
{
    /// MARK: CountriesViewControllerDelegate
    
    func countriesViewController(_ countriesViewController: BaseCountriesPicker, didSelectCountries countries: [Country]) {
        
        var res = ""
        countries.forEach { (co) in
            res = res + co.name + "\n";
        }
        print("Countries : \(res)")
        
    }
    
    func countriesViewControllerDidCancel(_ countriesViewController: BaseCountriesPicker) {
        print("user hass been tap cancel\n")
        
    }
    
    func countriesViewController(_ countriesViewController: BaseCountriesPicker, didSelectCountry country: Country) {
        
        print("\(country.name) selected")
        
        
    }
    
    func countriesViewController(_ countriesViewController: BaseCountriesPicker, didUnselectCountry country: Country) {
        
        print("\(country.name) unselected")
        
    }
}

