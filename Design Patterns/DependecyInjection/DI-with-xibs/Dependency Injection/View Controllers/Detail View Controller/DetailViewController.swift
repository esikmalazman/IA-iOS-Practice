//
//  DetailViewController.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 29/01/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentsLabel: UILabel!
    // MARK: - Properties
    static let nibName = "DetailViewController"
    
    private let note: Note
    
    init(with note : Note) {
        self.note = note
        super.init(nibName: DetailViewController.nibName, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You should not initiate this vc by invoking init(coder:)")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure Labels
        titleLabel.text = note.title
        contentsLabel.text = note.contents
    }
    
    // MARK: - Actions
    @IBAction func done(_ sender: Any) {
        // Dismiss View Controller
        dismiss(animated: true)
    }
}
