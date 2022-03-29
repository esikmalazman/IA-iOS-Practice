//
//  AppDelegate.swift
//  Tabs
//
//  Created by Bart Jacobs on 21/08/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    var window: UIWindow?

    // MARK: - Application Life Cycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 1. Ask window for its RootViewControler as cast to UITabBarControllers class
        
        guard let rootVC = window?.rootViewController as? TabBarController else {
            fatalError("Unexpected RootViewController")
        }
        
        // 2. Inject dependencies of TabBarVC with property injection
        rootVC.applicationManager = ApplicationManager()
        return true

    }

}
