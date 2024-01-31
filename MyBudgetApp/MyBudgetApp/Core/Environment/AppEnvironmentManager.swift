//
//  AppEnvironmentManager.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 1/31/24.
//

import Foundation
import Combine

@Observable
final class AppEnvironmentManager {
    
    static let instance = AppEnvironmentManager()
    
    var showDebugSettings: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    var showDebugMenu: Bool = false
    
    private init() {}
}
