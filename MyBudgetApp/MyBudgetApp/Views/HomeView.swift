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
    @StateObject var vm = HomeViewModel()
    @State private var showingFullScreenCover: Bool = false
    @State private var navPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ZStack {
                Color.gray.opacity(0.15).ignoresSafeArea()
                
                if vm.isLoadingResults {
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
            .navigationDestination(for: InputViewType.self, destination: { type in
                switch type {
                case .addBudget:
                    Text("Hello Add Budget View")
                case .addTransaction:
                    CreateTransactionView(tags: vm.allTags)
                case .addTag:
                    Text("Hello Add Tag View")
                }
            })
            .navigationTitle("MyBudget App")
            .toolbar(content: {
                ToolbarItemGroup {
                    Button {
                        
                    } label: {
                        Image(systemName: "person.crop.circle")
                    }
                    
                    if vm.appEnv.showDebugSettings {
                        Button {
                            vm.appEnv.showDebugMenu = true
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
            })
            .sheet(isPresented: $vm.appEnv.showDebugMenu) {
                DebugView()
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
                await vm.onAppear()
            }
        })
    }
    
    @ViewBuilder
    private var currentBudgets: some View {
        if !vm.currentBudgets.isEmpty {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(vm.currentBudgets) { budget in
                        CurrentBudgetCardView(budget: budget,
                                              amountSpent: vm.currentBudgetsTotalSpending[budget.id] ?? 0)
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
            
            ForEach(vm.transactions) { transaction in
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
                    ForEach(vm.allTags) { tag in
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
    HomeView(vm: HomeViewModel(currentBudgets: [Budget(id: .init(), title: "Monthly Budget", startDate: .now, endDate: Date(timeInterval: 3600000, since: .now), startingAmount: 1234, categories: [])], transactions: [Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now), Transaction(id: .init(), title: "First Transactions", amount: 32.00, date: .now)], allTags: [Tag(id: .init(), title: "grocery"), Tag(id: .init(), title: "fast food"), Tag(id: .init(), title: "health care")]))
}
