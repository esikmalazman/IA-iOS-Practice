//
//  RootViewController.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 29/01/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//
import UIKit

//MARK: - DI Storyboards - Property Injection
final class RootViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    // MARK: - Properties
    enum Segue : String {
        case goToNoteDetails = "NoteDetails"
    }
    
    var notes = [Note]()
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier,
              let indexPath = tableView.indexPathForSelectedRow,
              let destination = segue.destination as? DetailViewController else {
                  return
              }
        let selectedNote = notes[indexPath.row]
        
        switch identifier {
#warning("Make sure the identifier is correct before inject")
        case Segue.goToNoteDetails.rawValue :
#warning("Injecting dependency to detail vc with property injection")
            destination.note = selectedNote
        default:
            break
        }
    }
}

//MARK: - UITableViewDataSource
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
    }
}
