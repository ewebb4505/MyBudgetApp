//
//  HomeView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

struct HomeView: View {
    enum InputViewType: Hashable {
        case addTransaction
        case addBudget
        case addTag
    }
    @StateObject var homeViewModel = HomeViewModel()
    @StateObject var loginCreateAccountViewModel = LoginCreateAccountViewModel()
    @State private var showingFullScreenCover: Bool = false
    @State private var navPath = NavigationPath()
    
    @State var showLoginScreenCover: Bool = false
    @State var blurRadius: CGFloat = 10
    
    var appEnv = AppEnvironmentManager.instance
    
    var body: some View {
        NavigationStack(path: $navPath) {
            Group {
                if homeViewModel.showEmptyViewBeforeLogin {
                    LoggedOutHomeView(showLoginScreenCover: $showLoginScreenCover)
                } else {
                    LoggedInHomeView(showingFullScreenCover: $showingFullScreenCover)
                        .environmentObject(homeViewModel)
                }
            }
            .onAppear(perform: {
                Task {
                    await homeViewModel.onAppear()
                }
            })
            .navigationDestination(for: InputViewType.self, destination: { type in
                switch type {
                case .addBudget:
                    Text("Hello Add Budget View")
                case .addTransaction:
                    CreateTransactionView(tags: homeViewModel.allTags)
                case .addTag:
                    Text("Hello Add Tag View")
                }
            })
            .navigationTitle("MyBudget App")
            .toolbar(content: {
                toolbarView
            })
            .sheet(isPresented: $homeViewModel.appEnv.showDebugMenu) {
                DebugView()
            }
            .fullScreenCover(isPresented: $showLoginScreenCover, content: {
                LoginCreateAccountView(vm: loginCreateAccountViewModel)
            })
            .onChange(of: appEnv.user) { [weak homeViewModel] _, newValue in
                if newValue != nil {
                    homeViewModel?.showEmptyViewBeforeLogin = false
                } else {
                    homeViewModel?.showEmptyViewBeforeLogin = true
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarView: some ToolbarContent {
        ToolbarItemGroup {
            if appEnv.userIsSignedIn() {
                Menu {
                    Button("Logout", action: {
                        Task {
                            await homeViewModel.logoutUser()
                        }
                    })
                } label: {
                    Image(systemName: "person.crop.circle")
                }
            }

            if homeViewModel.appEnv.showDebugSettings {
                Button {
                    homeViewModel.appEnv.showDebugMenu = true
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}

#Preview {
    HomeView(homeViewModel: HomeViewModel(currentBudgets: [Budget(id: .init(), title: "Monthly Budget", startDate: .now, endDate: Date(timeInterval: 3600000, since: .now), startingAmount: 1234, categories: [], totalSpent: 0)], transactions: [Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now)], allTags: [Tag(id: .init(), title: "grocery"), Tag(id: .init(), title: "fast food"), Tag(id: .init(), title: "health care")]), showLoginScreenCover: false)
}
