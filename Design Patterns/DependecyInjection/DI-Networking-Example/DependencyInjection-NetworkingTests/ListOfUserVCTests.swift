//
//  ListOfUserVCTest.swift
//  DependencyInjection-NetworkingTests
//
//  Created by Ikmal Azman on 27/03/2022.
// https://stackoverflow.com/questions/30832276/tests-for-custom-uitableviewcell-cellforrowatindexpath-crashes-with-nil-outlets

import XCTest
@testable import DependencyInjection_Networking

class ListOfUserVCTest : XCTestCase {
    /// Determine if tableview has no users
    func test_table_display_no_users() {
        let vc = ListOfUserVC(nibName: ListOfUserVC.nibName, bundle: nil)
        vc.loadViewIfNeeded()
        
        let mockContract = MockNetworkManager()
        vc.contract = mockContract
        XCTAssertEqual(vc.users.count, 0)
        let numberOfRowInTV = vc.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(numberOfRowInTV, 0)
    }
    
    /// Determine if tableCell has no users
    func test_cell_have_no_user() {
        let vc = ListOfUserVC(nibName: ListOfUserVC.nibName, bundle: nil)
        let tableCell = Bundle(for: CustomTVCell.self).loadNibNamed(CustomTVCell.nibName, owner: nil, options: [:])?.first as! CustomTVCell
        vc.loadViewIfNeeded()
        
        let mockContract = MockNetworkManager()
        vc.contract = mockContract
        
        XCTAssertNotNil(tableCell)
        XCTAssertNil(tableCell.textLabel?.text)
    }
    
    /// Determine if tableCell has a user
    func test_cell_have_a_user() {
        let vc = ListOfUserVC(nibName: ListOfUserVC.nibName, bundle: nil)
        let tableCell = Bundle(for: CustomTVCell.self).loadNibNamed(CustomTVCell.nibName, owner: nil, options: [:])?.first as! CustomTVCell
        vc.loadViewIfNeeded()
        tableCell.textLabel?.text = "Ahmad"
        let mockContract = MockNetworkManager()
        vc.contract = mockContract
        
        XCTAssertNotNil(tableCell)
        XCTAssertNotNil(tableCell.textLabel?.text)
        XCTAssertEqual(tableCell.textLabel?.text, "Ahmad")
    }
}


//MARK: - Helpers method
/// Helper to determine item in single cell from dataSource
func cellForRow(in tableView : UITableView, row : Int, section :Int = 0) -> UITableViewCell? {
    tableView.cellForRow(at: IndexPath(item: row, section: section))
}
