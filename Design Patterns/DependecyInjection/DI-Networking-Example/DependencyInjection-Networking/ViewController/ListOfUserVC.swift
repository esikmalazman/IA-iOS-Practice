//
//  ListOfUserVC.swift
//  DependencyInjection-Modular-iOSAcademy
//
//  Created by Ikmal Azman on 27/03/2022.
//

import UIKit

final class ListOfUserVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static let nibName = "ListOfUserVC"
    // VC does not know the implementation and functionality of the object
    var contract : APIContract?
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            // Active function from injected dependencies and get the list of names
            let fetchedUsers  = try await contract?.fetchListOfUsers()
            self.users = fetchedUsers!
            self.tableView.reloadData()
        }
        tableView.dataSource = self
        tableView.register(CustomTVCell.nib(), forCellReuseIdentifier: CustomTVCell.identifier)
    }
    
    
}
//MARK: - UITableViewDataSource
extension ListOfUserVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTVCell.identifier, for: indexPath) as! CustomTVCell
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

