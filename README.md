# SwiftyBase

[![BuddyBuild](https://dashboard.buddybuild.com/api/statusImage?appID=59a6f3aeb749970001234046&branch=master&build=latest)](https://dashboard.buddybuild.com/apps/59a6f3aeb749970001234046/build/latest?branch=master)
[![Build Status](https://travis-ci.org/mspvirajpatel/SwiftyBase.svg?branch=master)](https://travis-ci.org/mspvirajpatel/SwiftyBase)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/mspvirajpatel/SwiftyBase/branch/master/graph/badge.svg)](https://codecov.io/gh/mspvirajpatel/SwiftyBase)
[![Version](https://img.shields.io/cocoapods/v/SwiftyBase.svg?style=flat)](http://cocoapods.org/pods/SwiftyBase)
[![License](https://img.shields.io/cocoapods/l/SwiftyBase.svg?style=flat)](http://cocoapods.org/pods/SwiftyBase)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyBase.svg?style=flat)](http://cocoapods.org/pods/SwiftyBase)


SwiftyBase makes it easy to deal with new Project create in Swift.

1. [Why use the SwiftyBase](#why-use-the-swiftybase)
2. [Requirements](#requirements)
3. [Integration](#integration)
4. [Usage](#usage)
	- [Initialization](#initialization)
	- [BaseViewController](#baseviewcontroller)
	- [BaseView](#baseview)
	- [BaseNavigationController](#basenavigationcontroller)
	- [BaseImageView](#baseimageview)
	- [BaseButton](#basebutton)
	- [BaseProgressHUD](#baseprogresshud)
	- [BaseRoundMenu](#baseroundmenu)
	- [BaseLabel](#baselabel)
	- [BaseTextField](#basetextfield)
	- [SideMenu](#sideMenu)
	- [AppImageUploadManager](#appimageuploadmanager)
	- [AppPlistManger](#appplistmanger)
	- [AppPreferencesExplorer](#apppreferencesexplorer)
5. [In Progress](#in-progress)
6. [Author](#author)


## Why use the SwiftyBase?

- In software development we all know that we have to reuse code as per as requirement so we have to utilise our code with less effort I will show you one demo on that first make one viewcontroller of baseviewcontroller then make one view of base view initialize this view in controller we can use this view in another controller too ...that’s the main purpose of baseview In storyboard or in one view controller have its own view..We all know that if we have work in owns view, then it will not use for another controller so we can implement on baseview & use it another times with simple initialize.


In Base Project included:
1. BaseViewController.swift
2. BaseView.swift
3. BaseNavigationController.swift
4. SideMenu

Extensions : 
1. Data
2. Date
3. Dictionary
4. NSArray
5. NSDictionary
6. UIColor
7. UINavigationController
8. UIScrollView
9. UITableView
10. UITextField
11. UIViewController
12. UIFont
13. UIView
14. String
15. UIImage

Utilities:

1. AppBaseLayout
2. AppConstants 
3. AppUtility
4. AppInterFaceUtility 
5. AppLocationManager
6. AppTimer
7. AppAlert
8. AppPreferencesExplorer
9. AppPlistManger
10. AppImageUploadManager

Controls: 

1. BaseImageView - with set Url image with catch support & Clear Catch
2. BaseButton - Multiple Button with single class access
3. Full screen Image Viewer  (ImageViewer)
4. BaseRoundMenu
5. BaseProgressHUD - Like MBProgressView
6. BaseLabel - Multiple BaseLabel with single class access 
7. BaseTextField - Multiple Textfield with single class access


## Requirements

- iOS 9.0+ 
- Xcode 8	


## Integration

#### CocoaPods (iOS 9)

You can use [CocoaPods](http://cocoapods.org/) to install `SwiftyBase`by adding it to your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
	pod 'SwiftyBase'
end
```

Note that this requires CocoaPods version 36, and your iOS deployment target to be at least 9.0:


#### Carthage (iOS 9+)

You can use [Carthage](https://github.com/Carthage/Carthage) to install `SwiftyBase` by adding it to your `Cartfile`:

```
github "mspvirajpatel/SwiftyBase"
```

#### Manually (iOS 9+)

To use this library in your project manually you may:  

1. Just drag ‘SwiftyBase/’ to the project tree



## Usage

#### Initialization

```swift
import SwiftyBase
```

#### BaseViewController

```swift
//If Create ViewContoller using BaseViewController

class ListController: BaseViewController {

    // MARK: - Attributes -
    
    // MARK: - Lifecycle -
    
    init() {

    }
    
}
```

#### BaseView

```swift
//If Create ListView using BaseView

class ListView: BaseView{
    
    // MARK: - Attributes -
    
    // MARK: - Lifecycle -
    
    override init(frame: CGRect) {
        super.init(frame:frame) 
        
    }
}

```
 

#### BaseNavigationController

```swift
//using BaseNavigationController
let listview : ListController = ListController()
        
let baseNavigation : BaseNavigationController = BaseNavigationController(rootViewController: listview)

```


#### BaseImageView

```swift
//using BaseImageView for set Image Local or Remote URL

let imgView : BaseImageView = BaseImageView(type: .profile, superView: self)
imgView.layer.setValue("imgView", forKey: ControlConstant.name)

//Set Remote URL for Download and set in Image View
imgView.setImageURL("Enter Your URL")
        
//For Full Screen Image Show on tap on Image
imgView.setupForImageViewer()

```


#### BaseButton 

```swift
//using BaseButton for set Button with case primary, secondary, radio, rounded Close, close, checkbox, dropdown, transparent 
 
let btnPrimary : BaseButton = BaseButton.init(ibuttonType: .primary, iSuperView: self)
btnPrimary.layer.setValue("btnPrimary", forKey: ControlConstant.name)
btnPrimary.setTitle("Primary Button", for: UIControlState())
        
let btnSecondary : BaseButton = BaseButton.init(ibuttonType: .secondary, iSuperView: self)
btnSecondary.layer.setValue("btnSecondary", forKey: ControlConstant.name)
btnSecondary.setTitle("Secondary Button", for: UIControlState())


```


#### BaseProgressHUD 

```swift

//Just the loader

BaseProgressHUD.shared.showInView(view: view)

```

```swift

// Add title and footer text
BaseProgressHUD.shared.showInView(view: view, withHeader: "Loading", andFooter: "Please wait...")

```

```swift

// Set color to the header, footer, loader or to the background view

BaseProgressHUD.setHeaderColor(color: UIColor.blue)
BaseProgressHUD.setFooterColor(color: UIColor.blue)
BaseProgressHUD.setLoaderColor(color: UIColor.blue)
BaseProgressHUD.setBackgroundColor(color: UIColor.white)

```

```swift

// Customize: Set color the the background view and let header, footer and loader infer a contrast color
BaseProgressHUD.setBackgroundColor(color: UIColor.white, automaticTextColor: true)

```

```swift

// Or show in a window
BaseProgressHUD.shared.showInWindow(window: window, withHeader: "Loading", andFooter: "Please wait...")

```

```swift

// Hide the HUD
BaseProgressHUD.shared.hide()

```

```swift

// Check if HUD is already being displayed
if BaseProgressHUD.shared.isActive {
    print("Currently showing HUD")
} else {
    print("HUD is currently hidden")
}

```


####  BaseRoundMenu

```swift
//using BaseRoundMenu for set Button with case center,topLeft,topRight,bottomLeft,bottomRight

let btncenter = BaseRoundMenu(withPosition: .center, size: 50.0, numberOfPetals: 10, images:[])
let btntopLeft = BaseRoundMenu(withPosition: .topLeft, size: 50.0, numberOfPetals: 4, images:[])
let btntopRight = BaseRoundMenu(withPosition: .topRight, size: 50.0, numberOfPetals: 4, images:[])
let btnbottomLeft = BaseRoundMenu(withPosition: .bottomLeft, size: 50.0, numberOfPetals: 4, images:[])
let btnbottomRight = BaseRoundMenu(withPosition: .bottomRight, size: 50.0, numberOfPetals: 4, images:[])

self.view.addSubview(btncenter)
self.view.addSubview(btntopLeft)
self.view.addSubview(btntopRight)
self.view.addSubview(btnbottomLeft)
self.view.addSubview(btnbottomRight)

btncenter = { (indexSelected) in
    debugPrint("Selected Index: \(indexSelected)")
}


```

####  BaseLabel

```swift

//using BaseLabel for set diffrent types of Buttons

let lblUserName : BaseLabel = BaseLabel(labelType: .small, superView: self)

let lblUserRealName = BaseLabel(labelType: .large, superView: self)


```

####  [BaseTextField]

```swift

//using BaseTextField for set diffrent types of BaseTextField like Password, Email

let baseTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .primary)

let baseTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .showPassword)

let baseTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .withoutClear)

let baseTextField : BaseTextField = BaseTextField.init(iSuperView: self, TextFieldType: .noAutoScroll)

```

####  SideMenu

```swift

//using SideMenu for set Application Menu SideMenu
//SideMenu is a simple and versatile side menu control

let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: YourViewController)
menuLeftNavigationController.leftSide = true
// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration 
// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
// let menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as! UISideMenuNavigationController
SideMenuManager.menuLeftNavigationController = menuLeftNavigationController

let menuRightNavigationController = UISideMenuNavigationController(rootViewController: YourViewController)
// UISideMenuNavigationController is a subclass of UINavigationController, so do any additional configuration
// of it here like setting its viewControllers. If you're using storyboards, you'll want to do something like:
// let menuRightNavigationController = storyboard!.instantiateViewController(withIdentifier: "RightMenuNavigationController") as! UISideMenuNavigationController
SideMenuManager.menuRightNavigationController = menuRightNavigationController

// Enable gestures. The left and/or right menus must be set up above for these to work.
// Note that these continue to work on the Navigation Controller independent of the view controller it displays!
SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)


// For Custom Open with Button Click
present(SideMenuManager.menuLeftNavigationController!, animated: true, completion: nil)

// Similarly, to dismiss a menu programmatically, you would do this:
dismiss(animated: true, completion: nil)


```


####  AppImageUploadManager

```swift

//using AppImageUploadManager for Multiple Image Upload and track with number of remain with Progress

//Add Upload in Multiple Images 

var arrImage : [UIImage]? = [Add Your Images]

let isUploadAdded : Bool = AppImageUploadManager.sharedInstance.addImageForUpload(arrImage: arrImage!)
if isUploadAdded
{
    print("new Image Added")
}


//Progress Getting

AppImageUploadManager.sharedInstance.setUpdateProgressStatusEven { (wasSuccessfull, object) in
    // object is Kind of "object as! NSArray"

    self.updateImageProgress(arrCount: object as! NSArray)
}

open func updateImageProgress(arrCount : NSArray) -> Void
{
    print("Uploading (\(arrCount[0])\\\(arrCount[1]))")

    let uploadedImg : Float = Float(arrCount[0] as! Int)
    let totalImg : Float = Float(arrCount[1] as! Int)

    print("Completed : \(arrCount.firstObject)" , "Total : \(arrCount[1])")
    print("Progress : \(uploadedImg / totalImg)")

    if arrCount[0] as! Int == arrCount[1] as! Int
    {
        print("Upload is completed...")
    }
}


```


####  AppPlistManger

```swift

//using AppPlistManger for Management of Plist file store & read Data

//For Read Plist File (Link :- "Menu")
for menuData in AppPListManager().readFromPlist("Your Plist File Name without .plist Extension") as! NSMutableArray
{
    let dicMenu : NSMutableDictionary = menuData as! NSMutableDictionary
    var arrItem : [NSDictionary] = []
    ...
}


```

####  AppPreferencesExplorer

```swift

//using AppPreferencesExplorer open Settings Page in IPhone or IPad

do{
    try AppPreferencesExplorer.open(.locationServices)
}
catch let error{
    print(error.localizedDescription)
}


```


## In Progress

- Description after some time added.(In Progress)


## Author

Viraj Patel, mspviraj@hotmail.com

## License

SwiftyBase is available under the MIT license. See the LICENSE file for more info.
