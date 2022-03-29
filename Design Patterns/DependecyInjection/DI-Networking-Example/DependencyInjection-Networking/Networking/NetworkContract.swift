//
//  NetworkContract.swift
//  DependencyInjection-Modular-iOSAcademy
//
//  Created by Ikmal Azman on 27/03/2022.
//

import Foundation

// Create protocol that have same name as function in to fetch API to allow simplicity in DI
// Use protocol as a type to bridge between network manager to current vc, without the vc know how it iniate
protocol APIContract {
    func fetchListOfUsers() async throws -> [User]
}
