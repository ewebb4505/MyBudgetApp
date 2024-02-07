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
    var appEnv = AppEnvironmentManager.instance
    
    @State var showLoginView: Bool = false
    var body: some Scene {
        WindowGroup {
            Group {
                HomeView(showLoginScreenCover: $showLoginView)
            }
            .fullScreenCover(isPresented: $showLoginView, content: {
                LoginCreateAccountView()
            })
            .onChange(of: appEnv.user) { _, newValue in
                if newValue != nil {
                    showLoginView = false
                }
            }
        }
    }
}
