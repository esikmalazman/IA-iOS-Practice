//
//  CustomTVCell.swift
//  DependencyInjection-Modular-iOSAcademy
//
//  Created by Ikmal Azman on 27/03/2022.
//

import UIKit

final class CustomTVCell: UITableViewCell {
    
    static let nibName = "CustomTVCell"
    static let identifier = "cell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: CustomTVCell.nibName, bundle: Bundle.main)
    }
    
}
