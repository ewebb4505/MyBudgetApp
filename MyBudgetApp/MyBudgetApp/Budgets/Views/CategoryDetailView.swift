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
    @State private var showAddTransactionToBudgetCategoryView = false
    
    @State private var categoryTransactions: [Transaction] = []
    
    var body: some View {
        List {
            Section {
                ForEach(categoryTransactions) { transaction in
                    Text(transaction.title)
                }
            }
            
            Button {
                viewModel.budgetCategorySelected = category
                showAddTransactionToBudgetCategoryView = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Transaction")
                }
            }
        }
        .task {
            categoryTransactions = await viewModel.getBudgetCategoryTrackedTransactions(categoryID: category.id)
        }
        .navigationTitle(category.title)
        .sheet(isPresented: $showAddTransactionToBudgetCategoryView, onDismiss: {
            Task {
                await viewModel.assignTransactionToBudgetCategory()
            }
        }) {
            AddTransactionToBudgetCategoryView()
                .environment(viewModel)
        }
    }
}
