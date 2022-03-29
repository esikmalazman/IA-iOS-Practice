//
//  TabBarController.swift
//  Tabs
//
//  Created by Bart Jacobs on 21/08/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit
// TabBarController keep references to its connected childVC
final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    var applicationManager: ApplicationManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildVC()
    }
    
    // In storyboard the TabBarVC connected to other childVC with segues
    // This method does not help to configure the childVC to be added to TabBarVC, due to this method not been trigger when the childVC initialise
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("\(#function)\(#line)\(#file)")
    }
    
    
    func setupChildVC() {
        // Unwrap viewControllers property in TabBarVC
        guard let viewControllers = viewControllers else {
            return
        }
        
        // Iterate every childVC in TabBarVC and inject it needed dependencies
        viewControllers.forEach { viewController in
            
            var childVC : UIViewController?
            // Cast ViewController to type copy of UINavigationController
            if let navigationContorller = viewController as? UINavigationController {
                // If the vc is embed in UINavigationController, ask it ot provide first vc(RootViewController in NavigationStack) and assign to childVC
                childVC = navigationContorller.viewControllers.first
            } else {
                // If the vc is not embed UINavigationController it will be assign as childVC
                childVC = viewController
            }
            
            // Use pattern matching and value binding to access each vc
            switch childVC {
            case let currentViewController as RedViewController :
                // Set tab bar title
                currentViewController.title = "Red"
                currentViewController.color = .red
            case let currentViewController as GreenViewController :
                currentViewController.view.backgroundColor = .green
                currentViewController.title = "Green"
                // 1. Create copy of GreenViewModel
                let viewModel = GreenViewModel(title: "Green")
                // 2. Inject dependencies of childVC to its viewModel property
                currentViewController.viewModel = viewModel
                
            case let currentViewController as BlueViewController :
   
                // 1. Assign injected property in App Delegate to BlueVC
                currentViewController.applicationManager = applicationManager
                currentViewController.view.backgroundColor = .systemBlue
                currentViewController.title = "Blue"
            default :
                break
            }
        }
    }
}
