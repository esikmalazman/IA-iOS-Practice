//
//  NoteTableViewCell.swift
//  Dependency Injection
//
//  Created by Bart Jacobs on 01/02/2018.
//  Copyright © 2018 Bart Jacobs. All rights reserved.
//

import UIKit

final class NoteTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    
    static var reuseIdentifier: String { return String(describing: self) }
    
    // MARK: - Properties
    
    @IBOutlet var titleLabel: UILabel!
    
    // MARK: - Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
