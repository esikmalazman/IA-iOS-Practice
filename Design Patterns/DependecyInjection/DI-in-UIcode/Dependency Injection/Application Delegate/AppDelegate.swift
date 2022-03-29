//
//  AppDelegate.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 29/01/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    var window: UIWindow?

    // MARK: -
    
    var notes: [Note] {
        return [
            Note(title: "Monday, January 11", contents: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur ac dolor justo, ac tempus leo. Etiam pulvinar eros at lectus sollicitudin scelerisque."),
            Note(title: "Another Day", contents: "Aliquam erat volutpat. Suspendisse eu eros non elit blandit suscipit. Morbi scelerisque euismod tempus. Vestibulum elementum tincidunt tempor. Mauris sodales tristique adipiscing."),
            Note(title: "Ideas", contents: "Sed venenatis lorem quis eros hendrerit consequat. Sed a est leo. Donec sapien libero, rutrum eget luctus ac, accumsan vel lectus. Ut quis libero ante. Ut volutpat, massa ac aliquam molestie, neque est blandit diam, non adipiscing purus magna vitae massa."),
            Note(title: "Help", contents: "Vestibulum fermentum consectetur sem, non aliquet nisl varius porta. Nulla consectetur tellus vel nibh tincidunt nec tincidunt nunc pellentesque. Etiam vel arcu sit amet quam auctor tincidunt commodo eu leo. Aliquam in arcu nulla. Donec eget imperdiet dui. Praesent vitae odio leo. Morbi bibendum lobortis sapien sit amet posuere.")
        ]
    }
    
    // MARK: - Application Life Cycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // 1. Initialize Root View Controller
        let rootViewController = RootViewController()
        // 2. Injected dependencies into vc with property injection
        rootViewController.notes = notes
        
        // Initialize Window
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Configure Window
        window?.rootViewController = rootViewController
        
        // Make Key and Visible
        window?.makeKeyAndVisible()
        
        return true
    }
    
}
