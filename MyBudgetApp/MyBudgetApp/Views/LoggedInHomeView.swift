//
//  LoggedInHomeView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct LoggedInHomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @Binding var showingFullScreenCover: Bool
    
    var body: some View {
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
                
                //fab
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
