//
//  MyBudgetAppApp.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

@main
struct MyBudgetAppApp: App {
    var appEnv = AppEnvironmentManager.instance
    @State private var showHomeScreen: Bool = false
    var body: some Scene {
        WindowGroup {
            Group {
                if !showHomeScreen {
                    LoginCreateAccountView()
                        .transition(.slide.combined(with: .opacity))
                } else {
                    HomeView()
                        .transition(.slide.combined(with: .opacity))
                }
            }
            .onAppear {
                showHomeScreen = appEnv.user != nil
            }
            .onChange(of: appEnv.user) { _, newValue in
                if newValue != nil {
                    showHomeScreen = true
                }
            }
        }
    }
}
