//
//  TaskCell.swift
//  ToDoList-CloudKit
//
//  Created by Ikmal Azman on 05/03/2022.
//

import UIKit
import CloudKit

protocol TaskCellDelegate : AnyObject {
    /// Allow passed modified cell to view that conform the protocol
    func updateTask(_ record : CKRecord)
}
final class TaskCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton! 
    
    //MARK: - Variables
    static let identifier = "TaskCell"
    var isChecked = false
    var record : CKRecord?
    
    weak var delegate : TaskCellDelegate?
    
    private let checkedIcon = UIImage(systemName: "checkmark.circle.fill")
    private let unCheckedIcon = UIImage(systemName: "checkmark.circle")
    
    //MARK: - LifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        taskTitleLabel.text = nil
        createdAtLabel.text = nil
        isChecked = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectionStyle = .none
        let padding = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 15)
        contentView.frame = contentView.frame.inset(by: padding)
        contentView.layer.cornerRadius = 10
    }
    
    static func nib()->UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    func setCell(records data : CKRecord) {
        self.record = data
        
        
        taskTitleLabel.text = data.object(forKey: "title") as? String ?? ""
        if let createdDate = data.object(forKey: "createdAt") as? Date {
            createdAtLabel.text = createdDate.convertToMonthYearDayFormat()
        } else {
            createdAtLabel.text = ""
        }
        
        if let checked = data.object(forKey: "checked") as? Int64 {
            self.isChecked = checked == 0 ? false : true
            checkButton.setBackgroundImage(self.isChecked ? checkedIcon : unCheckedIcon, for: .normal)
            checkButton.tintColor = isChecked ? .systemGreen : .systemGray
        } else {
            self.isChecked = false
            checkButton.setBackgroundImage(unCheckedIcon, for: .normal)
        }
    }
    
    
}

//MARK: - Actions
extension TaskCell {
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        toggleChecker()
    }
    
}

private extension TaskCell {
    /// Allow to change the completed task icon
    func toggleChecker() {
        guard let record = record else {
            return
        }
        
        isChecked.toggle()
        checkButton.setBackgroundImage(isChecked ? checkedIcon : unCheckedIcon, for: .normal)
        checkButton.tintColor = isChecked ? .systemGreen : .systemGray
        
        // Determine value of checked, Checked = 1, Unchecked 0
        let checkedValue = Int64( isChecked ? 1 : 0)
        // Assign value to checked property in cloud
        record.setObject(checkedValue as __CKRecordObjCValue, forKey: "checked")
        // Pass data that selected to other vc
        delegate?.updateTask(record)
    }
}
