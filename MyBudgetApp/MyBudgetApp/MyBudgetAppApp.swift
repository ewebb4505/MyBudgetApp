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
    @StateObject var transactionViewModel: TransactionsViewModel = .init()
    @StateObject var tagsViewModel: TagsMainTabViewModel = .init()
    
    @State private var selection: String = "0"
    var body: some Scene {
        WindowGroup {
            Group {
                TabView(selection: $selection) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag("0")
                    TransactionMainTabView(viewModel: transactionViewModel)
                        .tabItem {
                            Label("Transactions", systemImage: "dollarsign.arrow.circlepath")
                        }
                        .tag("1")
                    Text("Budgets")
                        .tabItem {
                            Label("Budgets", systemImage: "creditcard.fill")
                        }
                        .tag("2")
                    TagsMainTabView(viewModel: tagsViewModel)
                        .tabItem {
                            Label("Tags", systemImage: "tag.fill")
                        }
                        .tag("3")
                }
            }
        }
    }
}
