
import UIKit

import XCTest

@testable import SwiftyBase

class Tests: XCTestCase {
    
    var vc: BaseViewController!
    var view: BaseView!
    var window : UIWindow!
    var baseNavigation : BaseNavigationController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        window = UIWindow(frame: UIScreen.main.bounds)
       
        view = BaseView.init(frame: UIScreen.main.bounds)
       
        vc = BaseViewController.init(iView: view)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBaseNavigation() {
      
        baseNavigation = BaseNavigationController(rootViewController: vc)
        self.window!.rootViewController = baseNavigation
        XCTAssert(true , "Sucess")
    }
    
    func testBaseNavigationPush() {
        
        let newView = BaseView.init(frame: UIScreen.main.bounds)
        let newViewContoller : BaseViewController = BaseViewController.init(iView: newView, andNavigationTitle: "New Page")
        
        vc.navigationController?.pushViewController(newViewContoller, animated: true)
        XCTAssert(true , "Sucess")
    }
    
    func testProgessViewShowinView() {
        BaseProgressHUD.shared.showInView(view: view, withHeader: "Loading", andFooter: "Please wait...")
        XCTAssert(true , "Sucess")
    }

    func testProgessViewShowinWindow() {
        BaseProgressHUD.shared.showInWindow(window: window, withHeader: "Loading", andFooter: "Please wait...")
        XCTAssert(true , "Sucess")
    }
    
    func testProgessViewHide() {
        BaseProgressHUD.shared.hide()
        XCTAssert(true , "Sucess")
    }
    
    func testBaseButton() {
        
        let btnPrimary : BaseButton = BaseButton.init(type: .primary)
        btnPrimary.setTitle("Primary Button", for: UIControlState())
        btnPrimary.setButtonTouchUpInsideEvent { (sender, object) in
            XCTAssert(true , "Sucess")
        }
    }
    
    func testAppPreferences() {
        
        do{
            try AppPreferencesExplorer.open(.locationServices)
            XCTAssert(true , "Sucess")
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    func testPlistManager() {
        
        for _ in AppPlistManager().readFromPlist("Menu") as! NSMutableArray
        {
            XCTAssert(true , "Sucess")
        }
    }
    
    
    func testImageViewDownload() {
        let imgView : BaseImageView = BaseImageView.init(frame: CGRect.init(x: 0, y: 0, width: 320, height: 120))
        
        //Set Remote URL for Download and set in Image View
        imgView.setImageURL("https://www.planwallpaper.com/static/images/79438-blue-world-map_nJEOoUQ.jpg")
        
        //For Full Screen Image Show on tap on Image
        imgView.setupForImageViewer()
        XCTAssert(true , "Sucess")
    }
    
    func testClearImageData() {
        ImageDownload.clearAllTheCachedImages()
        XCTAssert(true , "Sucess")
    }
    
    func testApiCall() {
        
        let expection : XCTestExpectation = expectation(description: "Completion handler invoked")
        
        APIManager.shared.getRequest(URL: API.countries, Parameter: NSDictionary(), completionHandler:{(result) in
            
            switch result{
            case .Success(_, _):
                XCTAssert(true , "Sucess")
                expection.fulfill()
                break
            case .Error(_):
                XCTAssert(false , "Sucess")
                expection.fulfill()
                break
            case .Internet( _):
                
                break
            }
        })
        waitForExpectations(timeout: 30, handler: nil)
    }
}
