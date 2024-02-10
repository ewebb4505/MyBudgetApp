//
//  MyAppDelegate.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/6/24.
//

import UIKit

class MyAppDelegate: NSObject, UIApplicationDelegate, ObservableObject {
    private var appEnv = AppEnvironmentManager.instance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Task {
            await appEnv.setUserOnLaunch()
        }
        return true
    }
}
