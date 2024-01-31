//
//  AddTransactionToBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Evan Webb on 11/8/23.
//

import SwiftUI

struct AddTransactionToBudgetCategoryView: View {
    @StateObject var vm = AddTransactionToBudgetCategoryViewModel()
    
    var body: some View {
        List(vm.budgets) { budget in
            NavigationLink {
                TransactionsInBudgetsView(vm: vm, budget: budget)
                    .navigationTitle("Transactions")
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(budget.title)")
                            .font(.body)
                            .foregroundStyle(.primary)
                        
                        HStack {
                            Text("\(budget.startDate.formatted(date: .numeric, time: .omitted))")
                            +
                            Text(" → ")
                            +
                            Text("\(budget.endDate.formatted(date: .numeric, time: .omitted))")
                        }
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        
                        ForEach(budget.categories) { category in
                            HStack {
                                Text("\(category.title) · $\(String(format: "%.2f", category.maxAmount))")
                                    .font(.caption)
                                    .foregroundStyle(.tertiary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Select Budget")
        .onAppear {
            Task {
                await vm.getBudgets()
            }
        }
    }
}

struct TransactionsInBudgetsView: View {
    @ObservedObject var vm: AddTransactionToBudgetCategoryViewModel
    var budget: Budget
    
    @State private var selectedCategory: BudgetCategory?
    
    var body: some View {
        List(vm.transactionsInBudgetTimeline) { transaction in
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.title)
                        .font(.body)
                    Text("$\(String(format: "%.2f", transaction.amount))")
                        .font(.caption2)
                }
                
                Spacer()
                
                Picker("", selection: $selectedCategory) {
                    Text("No Category").tag(nil as BudgetCategory?)
                    ForEach(budget.categories) { category in
                        Text(category.title)
                            .tag(category as BudgetCategory?)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await vm.getTransactionsInBudgetDateRange(budget)
            }
        }
    }
}

#Preview {
    AddTransactionToBudgetCategoryView()
}
