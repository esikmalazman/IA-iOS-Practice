//
//  NetworkManager.swift
//  DependencyInjection-Modular-iOSAcademy
//
//  Created by Ikmal Azman on 27/03/2022.
//

import Foundation

// Responsible to fetch data from API
final class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchListOfUsers() async throws -> [User] {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            return []
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode([User].self, from: data)
            print("Users : \(user)")
            return user
        } catch {
            print("Error fetching data with error : \(String(describing: error))")
            return []
        }
    }
}

// Conforming network manager to APIContract type, allow to be inject in vc to fetch users
extension NetworkManager : APIContract {}
