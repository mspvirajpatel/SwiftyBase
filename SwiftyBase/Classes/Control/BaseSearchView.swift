//
//  BaseSearchView.swift
//  Pods
//
//  Created by MacMini-2 on 12/09/17.
//
//

import Foundation
import UIKit

public protocol BaseSearchDelegate {
    func hideSearchView(status : Bool)
}

open class BaseSearchView: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Properties
    public let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.shared.statusBarFrame)
        st.backgroundColor = UIColor.black
        st.alpha = 0.15
        return st
    }()
    
    lazy public var searchView: UIView = {
        let sv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 68))
        sv.backgroundColor = UIColor.white
        sv.alpha = 0
        return sv
    }()
    lazy public var backgroundView: UIView = {
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.black
        bv.alpha = 0
        return bv
    }()
    lazy public var backButton: UIButton = {
        let bb = UIButton.init(frame: CGRect.init(x: 0, y: 20, width: 48, height: 48))
        bb.setBackgroundImage(UIImage.init(named: "cancel"), for: [])
        bb.addTarget(self, action: #selector(BaseSearchView.dismiss), for: .touchUpInside)
        return bb
    }()
    lazy public var searchField: UITextField = {
        let sf = UITextField.init(frame: CGRect.init(x: 48, y: 20, width: self.frame.width - 50, height: 48))
        sf.placeholder = "Seach"
        sf.keyboardAppearance = .dark
        return sf
    }()
    lazy public var tableView: UITableView = {
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.frame.width, height: 288))
        return tv
    }()
    public var items = [String]()
    
    public var delegate:BaseSearchDelegate?
    
    //MARK: Methods
    func customization()  {
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(BaseSearchView.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.backButton)
        self.tableView.register(searchCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
        self.searchField.delegate = self
        self.addSubview(self.statusView)
        
    }
    
    public func animate()  {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchField.becomeFirstResponder()
        })
    }
    
    public func dismiss()  {
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
        }, completion: {(Bool) in
            self.delegate?.hideSearchView(status: true)
        })
    }
    
    public func requestSuggestionsURL(text: String) -> URL {
        let netText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet())!
        let url = URL.init(string: "https://api.bing.com/osjson.aspx?query=\(netText)")!
        return url
    }
    
    //MARK: TextField Delegates
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (self.searchField.text == "" || self.searchField.text == nil) {
            self.items = []
            self.tableView.removeFromSuperview()
        } else{
            let _  = URLSession.shared.dataTask(with: requestSuggestionsURL(text: self.searchField.text!), completionHandler: { (data, response, error) in
                if error == nil {
                    do {
                        let json  = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSArray
                        self.items = json[1] as! [String]
                        DispatchQueue.main.async(execute: {
                            if self.items.count > 0  {
                                self.addSubview(self.tableView)
                            } else {
                                self.tableView.removeFromSuperview()
                            }
                            self.tableView.reloadData()
                        })
                    } catch _ {
                        print("Something wrong happened")
                    }
                } else {
                    print("error downloading suggestions")
                }
            }).resume()
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss()
        return true
    }
    
    //MARK: TableView Delegates and Datasources
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! searchCell
        cell.itemLabel.text = items[indexPath.row]
        cell.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchField.text = items[indexPath.row]
    }
    
    //MARK: Inits
    override public init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func layoutSubviews() {
        self.tableView.separatorStyle = .none
    }
}

class searchCell: UITableViewCell {
    
    lazy var itemLabel: UILabel = {
        let il: UILabel = UILabel.init(frame: CGRect.init(x: 48, y: 0, width: self.contentView.bounds.width - 48, height: self.contentView.bounds.height))
        il.textColor = UIColor.gray
        return il
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
        self.addSubview(itemLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
