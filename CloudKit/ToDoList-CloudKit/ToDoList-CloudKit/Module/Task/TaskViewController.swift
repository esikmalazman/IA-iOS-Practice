//
//  ViewController.swift
//  ToDoList-CloudKit
//
//  Created by Ikmal Azman on 05/03/2022.
// https://betterprogramming.pub/swift-it-yourself-develop-a-to-do-app-with-cloudkit-e029e820df43

import UIKit
import CloudKit

final class TaskViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var taskTableView: UITableView!
    
    //MARK: - Variables
    var tasks = [CKRecord]()
    var manager = CloudKitManager()
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchRecords()
    }
    /// Set task
    func set(tasks: [CKRecord]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
    }
    
    /// Remove task at selected index
    func deleteTask(at indexPath : IndexPath, with rowAnimation : UITableView.RowAnimation = .right) {
        
        tasks.remove(at:  indexPath.row)
        DispatchQueue.main.async {
            self.taskTableView.deleteRows(at: [indexPath], with: rowAnimation)
            self.taskTableView.reloadData()
        }
    }
    
    func addTask(_ task : CKRecord) {
        tasks.insert(task, at: 0)
        DispatchQueue.main.async {
            self.taskTableView.reloadData()
        }
        
    }
    /// Retrieve tasks
    func fetchRecords() {
        manager.fetchTasks { records, error in
            guard error == .none, let records = records else {
                return
            }
            self.set(tasks: records)
        }
    }
}

//MARK: - Actions
extension TaskViewController {
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        
        var alertTextField = UITextField()
        let addTaskAlert = UIAlertController(title: "Add Task", message: "", preferredStyle: .alert)
  
        addTaskAlert.addTextField { text in
            text.placeholder = "Create your new task"
            alertTextField = text
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let task = alertTextField.text else {
                return
            }
            // Add task to iCloud
            self.manager.addTasks(task) { record, error in
                guard error == .none, let newTask = record else{
                    return
                }
                self.addTask(newTask)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addTaskAlert.addAction(cancelAction)
        addTaskAlert.addAction(addAction)
        present(addTaskAlert, animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension TaskViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: TaskCell.identifier, for: indexPath) as! TaskCell
        cell.delegate = self
        cell.setCell(records: tasks[indexPath.row])
        return cell
    }
    
    // Ask dataSource to make insert/delete for specified row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Get single task to delete
        let taskToDelete = tasks[indexPath.row]
        // Enable cell dragging for delete options
        if editingStyle == .delete {
            //            print("Task Delete : \(taskToDelete)")
            manager.deleteTasks(taskToDelete) { error in
                print("Error : \(error)")
                guard error == .none else {
                    return
                }
                
                self.deleteTask(at: indexPath)
            }
        }
    }
    
    /// Ask dataSource to verify if the row is editable
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

//MARK: - UITableViewDelegate
extension TaskViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        taskTableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - TaskCellDelegate
extension TaskViewController :TaskCellDelegate {
    func updateTask(_ record: CKRecord) {
        manager.updateTask(record) { record, error in
            print("Update for record : \(String(describing: record?.recordID.recordName)) success")
        }
    }
}

//MARK: -  Extensions
private extension TaskViewController {
    func setupTableView() {
        taskTableView.register(TaskCell.nib(), forCellReuseIdentifier: TaskCell.identifier)
        taskTableView.delegate = self
        taskTableView.dataSource = self
    }
}
