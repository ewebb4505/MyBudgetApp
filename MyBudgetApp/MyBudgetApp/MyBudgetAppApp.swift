//
//  MyBudgetAppApp.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

@main
struct MyBudgetAppApp: App {
    @UIApplicationDelegateAdaptor(MyAppDelegate.self) var appDelegate
    
    
    var body: some Scene {
        WindowGroup {
            Group {
                HomeView()
            }
        }
    }
}
