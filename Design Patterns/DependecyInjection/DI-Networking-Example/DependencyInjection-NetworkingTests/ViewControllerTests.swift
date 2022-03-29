//
//  ViewControllerTests.swift
//  DependencyInjection-NetworkingTests
//
//  Created by Ikmal Azman on 27/03/2022.
// https://www.appsdeveloperblog.com/xctest-test-if-uibutton-is-connected-and-has-action/

import XCTest
@testable import DependencyInjection_Networking

class ViewControllerTests: XCTestCase {

    /// Determine if the outlet is already connected
    func test_button_is_connected() {
        let vc = createViewController()
        let tapButton = vc.tapMeBtn
        XCTAssertNotNil(tapButton)
    }
    /// Determine if button has an action
    func test_button_has_action() {
        let vc = createViewController()
        let tapMeAction = vc.tapMeBtn.actions(forTarget: vc, forControlEvent: .touchUpInside)
        XCTAssertTrue(tapMeAction!.contains("didTapMeButtonPressed:"))
    }
}

//MARK: - Helper
/// Create new vc instance
func createViewController() -> ViewController {
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let vc = sb.instantiateViewController(withIdentifier: "ViewController") as! ViewController
    vc.loadViewIfNeeded()
    return vc
}
