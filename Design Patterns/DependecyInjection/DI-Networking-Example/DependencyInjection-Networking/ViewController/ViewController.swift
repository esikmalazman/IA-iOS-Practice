//
//  ViewController.swift
//  DependencyInjection-Modular-iOSAcademy
//
//  Created by Ikmal Azman on 27/03/2022.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var tapMeBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: - Actions
extension ViewController {
    @IBAction func didTapMeButtonPressed(_ sender: UIButton) {
        let vc = ListOfUserVC(nibName: ListOfUserVC.nibName, bundle: Bundle.main)
        // Inject dependency to xib vc by property injection
        vc.contract = NetworkManager()
        present(vc, animated: true, completion: nil)
    }
}
