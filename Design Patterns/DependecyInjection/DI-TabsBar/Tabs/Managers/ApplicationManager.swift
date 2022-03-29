//
//  ApplicationManagerManager.swift
//  Tabs
//
//  Created by Bart Jacobs on 21/08/2018.
//  Copyright © 2018 Cocoacasts. All rights reserved.
//

import Foundation

class ApplicationManager {

    /// Retrive version number of the app
    var versionAsString: String {
        guard let infoDictionary = Bundle.main.infoDictionary else {
            return "-"
        }
        
        return infoDictionary["CFBundleShortVersionString"] as? String ?? "-"
    }
    
}
