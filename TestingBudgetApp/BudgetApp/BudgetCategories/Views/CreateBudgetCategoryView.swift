//
//  CreateBudgetCategoryView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/31/23.
//

import SwiftUI

struct CreateBudgetCategoryView: View {
    @StateObject var vm = CreateBudgetCategoryViewModel()
    
    var body: some View {
        List(vm.budgets) { budget in
            NavigationLink {
                BudgetCategoryFormView(vm: vm, budget: budget)
                    .navigationTitle("Add Category")
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
        .onAppear {
            Task {
                await vm.getBudgets()
            }
        }
    }
}
