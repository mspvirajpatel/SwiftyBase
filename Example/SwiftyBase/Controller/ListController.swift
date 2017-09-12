//
//  ListController.swift
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

class ListController: BaseViewController {

    // MARK: - Attributes -
    
    var listView: ListView!
    
    // MARK: - Lifecycle -
    
    required init() {
        listView = ListView(frame: CGRect.zero)
        super.init(iView: listView, andNavigationTitle: "List of Examples")
        self.loadViewControls()
        self.setViewlayout()
        self.displayMenuButton(image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    required init(iView: BaseView) {
        listView = ListView(frame: CGRect.zero)
        super.init(iView: listView, andNavigationTitle: "List of Examples")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    required init(iView: BaseView, andNavigationTitle titleString: String) {
        listView = ListView(frame: CGRect.zero)
        super.init(iView: listView, andNavigationTitle: "List of Examples")
        self.loadViewControls()
        self.setViewlayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
    }
    
    // MARK: - Layout -
    
    override func loadViewControls(){
        super.loadViewControls()
        
    }
    
    override func setViewlayout(){
        super.setViewlayout()
        super.expandViewInsideView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listView.animateTable()
    }
    
    
    // MARK: - Public Interface -
    
    
    
    // MARK: - User Interaction -
    
    
    
    // MARK: - Internal Helpers -

}
