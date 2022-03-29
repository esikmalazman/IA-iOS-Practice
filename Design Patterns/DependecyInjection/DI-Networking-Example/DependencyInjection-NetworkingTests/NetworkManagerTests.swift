//
//  DependencyInjection_NetworkingTests.swift
//  DependencyInjection-NetworkingTests
//
//  Created by Ikmal Azman on 27/03/2022.
//

import XCTest
@testable import DependencyInjection_Networking

final class NetworkManagerTests: XCTestCase {
    /// Determine if data return when fetch users
    func test_data_should_return_list_of_users() {
        let mock = MockNetworkManager()
        Task {
            mock.data = [
                createUser("Ali"),
                createUser("Abu"),
                createUser("Raju")
            ]
            let users = try await mock.fetchListOfUsers()
            XCTAssertNotNil(users)
            XCTAssertEqual(mock.data.count, 3)
            XCTAssertNoThrow(users)
        }
    }
    /// Determine if data is empty when fetch users
    func test_data_should_empty() {
        let mock = MockNetworkManager()
        Task {
            let emptyData = try await mock.fetchListOfUsers()
            print(emptyData)
            XCTAssertNil(emptyData)
            XCTAssertEqual(mock.data.count, 0)
            XCTAssertNoThrow(emptyData)
        }
    }
}

//MARK: - Mock Class
/// MockNetworkManager class that implement same protocol as NetworkManager class
final class MockNetworkManager : APIContract {
    
    var data : [User] = []

    func fetchListOfUsers() async throws -> [User] {
        return data
    }
    
}

//MARK: - Helper Methods
func createUser(_ name : String) -> User  {
    return User(name: name)
}


