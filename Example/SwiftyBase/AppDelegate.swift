//
//  AppDelegate.swift
//  SwiftyBase
//
//  Created by patelvirajd78@gmail.com on 08/30/2017.
//  Copyright (c) 2017 patelvirajd78@gmail.com. All rights reserved.
//

import UIKit
import SwiftyBase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigation: BaseNavigationController!
    var listView: ListController!
    
    // MARK: - Lifecycle -
    
    override init() {
        super.init()
        
        //before didFinishLaunchingWithOptions
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        BuddyBuildSDK.setup()
        
        // Override point for customization after application launch.
        
        // ClearAllTheCachedImages
        // ImageDownloader.clearAllTheCachedImages()
        
        self.dynamicSetValue()
        
        self.loadUI()
        
        return true
    }
    
    private func dynamicSetValue() {
        
        APIManager.shared.baseUrlString = API.baseURL
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    fileprivate func loadUI(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        self.displayListOnWindow()
        
        window?.makeKeyAndVisible()
        
    }
    
    func displayListOnWindow() {
        
        self.loadView()
        
        self.window!.rootViewController = self.navigation!
    }
    
    func loadView() {
        
        listView = nil
        navigation = nil
        
        self.listView = ListController()
        
        self.navigation = BaseNavigationController(rootViewController: self.listView)
        
    }
    
    
}

