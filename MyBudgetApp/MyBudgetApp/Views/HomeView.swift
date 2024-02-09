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
    
    var appEnv = AppEnvironmentManager.instance
    
    var body: some View {
        NavigationStack(path: $navPath) {
            Group {
                if homeViewModel.showEmptyViewBeforeLogin {
                    loggedOutView
                } else {
                    loggedInUserView
                }
            }
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
                ToolbarItemGroup {
                    Menu {
                        Button("Logout", action: {
                            Task {
                                await homeViewModel.logoutUser()
                            }
                        })
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }

                    
                    if homeViewModel.appEnv.showDebugSettings {
                        Button {
                            homeViewModel.appEnv.showDebugMenu = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
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
        .transparentNonAnimatingFullScreenCover(isPresented: $showingFullScreenCover, content: {
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Button {
                            showingFullScreenCover = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: DispatchWorkItem(block: {
                                navPath.append(InputViewType.addBudget)
                            }))
                        } label: {
                            Text("New Budget")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        
                        Button {
                            showingFullScreenCover = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: DispatchWorkItem(block: {
                                navPath.append(InputViewType.addTransaction)
                            }))
                        } label: {
                            Text("New Transaction")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        
                        Button {
                            showingFullScreenCover = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: DispatchWorkItem(block: {
                                navPath.append(InputViewType.addTag)
                            }))
                        } label: {
                            Text("New Tag")
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        
                        Button(action: {
                            showingFullScreenCover = false
                        }, label: {
                            Image(systemName: "minus")
                                .font(.body.weight(.bold))
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.white)
                        })
                        .background(Color.blue)
                        .cornerRadius(38.5)
                        .padding()
                        .shadow(color: Color.black.opacity(0.1),
                                radius: 3,
                                x: 3,
                                y: 3)
                    }
                    
                }
            }
        })
        .onAppear(perform: {
            Task {
                await homeViewModel.onAppear()
            }
        })
    }
    
    @ViewBuilder
    private var loggedInUserView: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
            
            if homeViewModel.isLoadingResults {
                ProgressView()
            } else {
                VStack(spacing: 16) {
                    currentBudgets
                    
                    lastTenTransactionsTable
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    
                    allTags
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal)
                    
                    Spacer()
                }
                
                fab
            }
        }
    }
    
    @ViewBuilder
    private var loggedOutView: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
            
            VStack {
                Text("Log your daily spending and create a budget to meet your money goals!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Button("Login or Create Account") {
                    showLoginScreenCover = true
                }
                .controlSize(.extraLarge)
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    private var currentBudgets: some View {
        if !homeViewModel.currentBudgets.isEmpty {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(homeViewModel.currentBudgets) { budget in
                        CurrentBudgetCardView(budget: budget,
                                              amountSpent: homeViewModel.currentBudgetsTotalSpending[budget.id] ?? 0)
                    }
                }
                .padding(.leading, 16)
            }
        } else {
            VStack {
                Text("You Have No Current Budgets!")
                NavigationLink {
                    Text("Create Budget View")
                } label: {
                    Text("Create Budget")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private var lastTenTransactionsTable: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Transactions")
                        .font(.title3)
                    Text("Most Recent")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                NavigationLink {
                    Text("Hello, Transactions Search Page")
                } label: {
                    Label("Search", systemImage: "magnifyingglass")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }
            
            ForEach(homeViewModel.transactions) { transaction in
                TransactionDataRow(transcation: transaction)
            }
            
            NavigationLink {
                Text("Hello, View All Transactions")
            } label: {
                HStack {
                    Spacer()
                    
                    Text("View More")
                        .foregroundStyle(.blue)
                    
                    Spacer()
                }
                .frame(height: 44)
            }
        }
        .padding()
        .background(.white)
    }
    
    private var allTags: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Tags")
                        .font(.title3)
                    Text("Track Transactions")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                NavigationLink {
                    Text("Hello, Tags Analytics Page")
                } label: {
                    HStack {
                        Text("Analytics")
                        Image(systemName: "chevron.right")
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            
            // way is this not showing?
            ScrollView(.horizontal) {
                HStack {
                    ForEach(homeViewModel.allTags) { tag in
                        TagBadge(tag: tag)
                    }
                }
            }
        }
        .padding()
        .background(.white)
    }
    
    private var fab: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                FABVew(image: Image(systemName: "plus")) {
                    withAnimation {
                        showingFullScreenCover = true
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(homeViewModel: HomeViewModel(currentBudgets: [Budget(id: .init(), title: "Monthly Budget", startDate: .now, endDate: Date(timeInterval: 3600000, since: .now), startingAmount: 1234, categories: [])], transactions: [Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now)], allTags: [Tag(id: .init(), title: "grocery"), Tag(id: .init(), title: "fast food"), Tag(id: .init(), title: "health care")]), showLoginScreenCover: false)
}
