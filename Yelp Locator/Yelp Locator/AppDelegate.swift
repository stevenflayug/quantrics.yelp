//
//  AppDelegate.swift
//  Yelp Locator
//
//  Created by Steven Layug on 9/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //TODO Change to landing page
        let businessListVC = UINavigationController(rootViewController: BusinessListViewController())
        window?.rootViewController = businessListVC
        return true
    }
}

