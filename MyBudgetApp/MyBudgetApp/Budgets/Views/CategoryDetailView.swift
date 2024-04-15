//
//  CategoryDetailView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 4/1/24.
//

import SwiftUI

struct CategoryDetailView: View {
    @Environment(BudgetDetailViewModel.self) private var viewModel
    
    var category: BudgetCategory
    let isActive: Bool
    
    @State private var showAddTransactionToBudgetCategoryView = false
    @State private var showCreateTransactionView = false
    @State private var categoryTransactions: [Transaction] = []
    @State private var showNotTrackedTransactionsMessage: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 2) {
                            Group {
                                Text(viewModel.budget.startDate.formatted(date: .abbreviated, time: .omitted))
                                Text("→")
                                Text(viewModel.budget.endDate.formatted(date: .abbreviated, time: .omitted))
                            }
                            .font(.body.weight(.light))
                        }
                        Group {
                            category.totalAmountSpent.displayUSD() 
                                .font(.body.weight(.medium))
                            +
                            Text(" out of ")
                                .font(.body.weight(.light))
                            +
                            category.maxAmount.displayUSD() 
                                .font(.body.weight(.medium))
                            +
                            Text (" spent ")
                                .font(.body.weight(.light))
                        }
                        
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listSectionSeparatorTint(.clear)
                .background(.clear)
                
                if !showNotTrackedTransactionsMessage {
                    Section {
                        ForEach(categoryTransactions) { transaction in
                            buildTransactionTablerow(transaction)
                        }
                    } header: {
                        HStack {
                            Text("Transactions (\(categoryTransactions.count))")
                        }
                    }
                }
            }
            
            if isActive {
                bottomButtonsView
                    .background(.white)
            }
        }
        .task {
            categoryTransactions = await viewModel.getBudgetCategoryTrackedTransactions(categoryID: category.id)
            showNotTrackedTransactionsMessage = categoryTransactions.isEmpty
        }
        .navigationTitle(category.title)
        .sheet(isPresented: $showAddTransactionToBudgetCategoryView) {
            Task { await viewModel.assignTransactionToBudgetCategory() }
        } content: {
            AddTransactionToBudgetCategoryView()
                .environment(viewModel)
        }
        .overlay {
            if showNotTrackedTransactionsMessage {
                Text("You have no tracked transactions for this category.")
            }
        }
    }
    
    private var bottomButtonsView: some View {
        VStack {
            Divider()
            VStack {
                Button {
                    viewModel.selectedBudgetCategoryForTransaction = category
                    viewModel.addCategoriesToCreateTransactionView = false
                    viewModel.showAddTransactionToBudgetCategoryView = true
                } label: {
                    createBottomButtonLabel("Create Transaction")
                }
                .controlSize(.large)
                .buttonStyle(.bordered)
                
                Button {
                    viewModel.budgetCategorySelected = category
                    showAddTransactionToBudgetCategoryView = true
                } label: {
                    createBottomButtonLabel("Add Transaction")
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)
            .padding(.vertical, 4)
        }
    }
    
    private func createBottomButtonLabel(_ str: String) -> some View {
        HStack {
            Spacer()
            Text(str)
                .bold()
                .minimumScaleFactor(0.8)
                .lineLimit(1)
            Spacer()
        }
    }
    
    private func buildTransactionTablerow(_ transaction: Transaction) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.title)
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            Spacer()
            transaction.amount.displayColoredUSD()
        }
    }
}
