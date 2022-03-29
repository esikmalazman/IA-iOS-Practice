//
//  ViewController.swift
//  AnimateAutoLayout
//
//  Created by Ikmal Azman on 15/02/2022.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var orangeView: UIView!
    @IBOutlet weak var orangeLeadingContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


    @IBAction func moveButtonPressed(_ sender: UIButton) {
        // Animate the view by remove contraint and add new constraint
        UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseIn) {
            self.view.removeConstraint(self.orangeLeadingContraint)
            // Set leading constraint to new constraint
            self.setupNewContraint()
            // Force layout before drawing
            self.view.layoutIfNeeded()
        }

        
    }
    
    func setupNewContraint() {
        NSLayoutConstraint.activate([
            orangeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.frame.width / 2)
        ])
    }
}

