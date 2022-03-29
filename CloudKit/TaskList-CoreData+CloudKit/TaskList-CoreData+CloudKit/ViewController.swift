//
//  ViewController.swift
//  TaskList-CoreData+CloudKit
//
//  Created by Ikmal Azman on 09/03/2022.
// Syncing data on iOS devices with CoreData and CloudKit
// https://medium.com/apple-developer-academy-federico-ii/syncing-data-on-ios-devices-with-coredata-and-cloudkit-bed296fc26e0

import UIKit

final class ViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskTextField: UITextField!
    
    //MARK: - Variables
    /// Array of type Task that stored in Core Data
    var taskList = Task.fetchAll()
    var enteredTask = ""
    
      //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
}

//MARK: - Actions
extension ViewController {
    @IBAction func addButtonTapped(_ sender: UIButton) {
        addNewTask()
    }
    
    @IBAction func resetButtonTap(_ sender: UIBarButtonItem) {
        deleteAllTask()
    }
    /// Add new task
    func addNewTask() {
        enteredTask = taskTextField.text!
        saveTask(named : enteredTask)
        taskList = Task.fetchAll()
        tableView.reloadData()
        taskTextField.text = ""
    }
    
    /// Delete all saved task in Core Data
    func deleteAllTask() {
        Task.deleteAll()
        taskList = Task.fetchAll()
        tableView.reloadData()
    }
    
    /// Save current task in Core data
    func saveTask(named name : String) {
        let task = Task(context: AppDelegate.viewContext)
        task.taskName = name
        try? AppDelegate.viewContext.save()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "- " + taskList[indexPath.row].taskName!
        return cell
    }
}

extension ViewController : UITableViewDelegate {}
