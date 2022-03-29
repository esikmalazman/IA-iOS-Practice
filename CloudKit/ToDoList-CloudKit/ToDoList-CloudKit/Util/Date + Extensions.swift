//
//  Date + Extensions.swift
//  ToDoList-CloudKit
//
//  Created by Ikmal Azman on 05/03/2022.
//

import Foundation

extension Date {
    /// Convert date to month, year, day format
    func convertToMonthYearDayFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}
