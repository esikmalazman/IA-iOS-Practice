//
//  GreenViewController.swift
//  Tabs
//
//  Created by Bart Jacobs on 21/08/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit
//MARK: - This VC embeded in NavigationController, NavigationContrller is child of TabBarViewController
final class GreenViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: -
    var viewModel: GreenViewModel?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set title of tab bar at this moment does not change anything, due to this method of childVC only active when it about to be presented and loaded lazily(Only run when been active)
        // ChildVC of TabBarVC is initialise when TabBarVC initialise
        title = "Green"
        // Setup View Model
        setupViewModel(with: viewModel)
    }
    
    // MARK: - Helper Methods
    
    private func setupViewModel(with viewModel: GreenViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        
        // Configure Title Label
        titleLabel.text = viewModel.title
    }
    
}
