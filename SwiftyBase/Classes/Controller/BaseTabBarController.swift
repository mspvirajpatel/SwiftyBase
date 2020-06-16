//
//  BaseTabBarController.swift
//  Pods
//
//  Created by MacMini-2 on 13/09/17.
//
//

import Foundation

class TabBarController: UITabBarController {

    // MARK: - Attributes -

    var arrayControllers: [BaseNavigationController]!

    var btnCount: UIButton!

    // MARK: - Lifecycle -
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.setUpTab()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true


    }

    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = SystemConstants.IS_IPAD ? 70 : 60
        tabFrame.origin.y = self.view.frame.size.height - (SystemConstants.IS_IPAD ? 70 : 60)
        self.tabBar.frame = tabFrame
    }

    deinit {
        print("TabBarController deinit called")
        NotificationCenter.default.removeObserver(self)

        arrayControllers = nil
    }

    // MARK: - Layout -


    // MARK: - Public Interface -


    // MARK: - User Interaction -

    private func setUpTab()
    {
        self.view.backgroundColor = .clear
        self.delegate = self
        var font: UIFont? = Font(.installed(.AppleMedium), size: SystemConstants.IS_IPAD ? .standard(.h2) : .standard(.h3)).instance

        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        appearance.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .selected)

//        for arrayControllers in arrayControllers {
//
//        }


//        homeNavigationController = BaseNavigationController(rootViewController: HomeView())
//        homeNavigationController.tabBarItem.title = "navHomeTitle".localize()
//        homeNavigationController.tabBarItem.image = UIImage(named: "Tabbar_Home")
//
//        cloudLoginNavigationController = BaseNavigationController(rootViewController: HomeView())
//        cloudLoginNavigationController.tabBarItem.title = "navTackerTitle".localize()
//        cloudLoginNavigationController.tabBarItem.image = UIImage(named: "Tabbar_Popular")

        self.viewControllers = arrayControllers


        do {
            font = nil
        }
    }

    // MARK: - Internal Helpers -

    // MARK: - Delegate Method -

    // MARK: - Server Request -
}

extension UITabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 1 {
            tabBarController.tabBar.items?[1].badgeValue = nil
        }

    }
}
