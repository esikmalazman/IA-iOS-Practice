//
//  BlueViewController.swift
//  Tabs
//
//  Created by Bart Jacobs on 21/08/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import UIKit

final class BlueViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet var versionLabel: UILabel!
    
    // MARK: -
    
    var applicationManager: ApplicationManager?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View
        setupView()
    }
    
    // MARK: - View Methods
    
    private func setupView() {
        // Configure Version Label
        versionLabel.text = applicationManager?.versionAsString
        versionLabel.textColor = .white
    }

}
