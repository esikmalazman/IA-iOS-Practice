//
//  RootViewController.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 29/01/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//

import UIKit

//MARK: - DI XIBs - Initializer,Property,Method Injection
// Responsible to initiate the initial vc of the project
final class RootViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    // MARK: - Properties
    static let nibName = "RootViewController"
    
    // 1.Create constant property that need to set during initialization
    private let notes : [Note]
    
    // 2. Create initializer to inject dependencies to current vc
    init(with notes : [Note]) {
        // 3. Set vc dependencies
        self.notes = notes
        // 4. Activate initializer from super class
        super.init(nibName: RootViewController.nibName, bundle: Bundle.main)
    }
    
    // 5. Implement required initializer of the vc class
    required init?(coder: NSCoder) {
        fatalError("You should not initiate this vc by invoking init(coder:)")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register XIB for Cell Reuse Identifier
        let xib = UINib(nibName: NoteTableViewCell.reuseIdentifier, bundle: Bundle.main)
        tableView.register(xib, forCellReuseIdentifier: NoteTableViewCell.reuseIdentifier)
    }
}

//MARK: -  UITableViewDataSource
extension RootViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to Dequeue Note Table View Cell")
        }
        // Fetch Note
        let note = notes[indexPath.row]
        
        // Configure Cell
        cell.titleLabel.text = note.title
        return cell
    }
    
}
//MARK: - UITableViewDelegate
extension RootViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Get single note
        let note = notes[indexPath.row]
        
        // 1. Initialize instance of DetailVC and pass the dependencies
        let detailVC = DetailViewController(with: note)
        // 2. Present the next screen
        present(detailVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
}
