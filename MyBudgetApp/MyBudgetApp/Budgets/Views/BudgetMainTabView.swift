//
//  BudgetMainTabView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/24/24.
//

import SwiftUI

struct BudgetMainTabView: View {
    @Bindable var viewModel: BudgetsMainTabViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.currentBudgets.isEmpty && viewModel.budgets.isEmpty {
                    VStack {
                        Spacer()
                        
                        Button {
                            viewModel.showCreateBudgetSheet = true
                        } label: {
                            Text("Create a budget")
                        }
                        
                        Spacer()
                    }
                } else {
                    List {
                        if !viewModel.currentBudgets.isEmpty {
                            Section {
                                ForEach(viewModel.currentBudgets) { budget in
                                    NavigationLink(value: budget) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(budget.title)
                                                    .font(.body)
                                                
                                                Group {
                                                    Text(budget.startDate.formatted(date: .abbreviated, time: .omitted))
                                                    +
                                                    Text(" → ")
                                                    +
                                                    Text(budget.endDate.formatted(date: .abbreviated, time: .omitted))
                                                }
                                                .font(.caption.weight(.light))
                                            }
                                            
                                            Spacer()
                                        }
                                        .swipeActions(edge: .trailing) {
                                            Button(role: .destructive) {
                                                Task { @MainActor in
                                                    await viewModel.deleteBudget(budgetID: budget.id)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                    }
                                }
                            } header: {
                                Text("Active Budgets")
                            }
                        }
                        
                        if !viewModel.budgets.isEmpty {
                            Section {
                                ForEach(viewModel.budgets) { budget in
                                    NavigationLink(value: budget) {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(budget.title)
                                                    .font(.body)
                                                
                                                Group {
                                                    Text(budget.startDate.formatted(date: .abbreviated, time: .omitted))
                                                    +
                                                    Text(" → ")
                                                    +
                                                    Text(budget.endDate.formatted(date: .abbreviated, time: .omitted))
                                                }
                                                .font(.caption.weight(.light))
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                }
                            } header: {
                                Text("Inactive Budgets")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Budgets")
            .navigationDestination(for: Budget.self, destination: { budget in
                BudgetDetailView(budget: budget,
                                 isActive: viewModel.currentBudgets.contains(where: { $0.id == budget.id }))
            })
            .task {
                await viewModel.fetchBudgets()
            }
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $viewModel.showCreateBudgetSheet) {
                CreateBudgetView(titleInput: $viewModel.createBudgetName,
                                 startingAmount: $viewModel.createBudgetStartingAmount,
                                 startDate: $viewModel.createBudgetStartDate,
                                 endDate: $viewModel.createBudgetEndDate) { [weak viewModel] in
                    guard let viewModel else {
                        return
                    }
                    
                    if await viewModel.createBudget() {
                        viewModel.showCreateBudgetSheet = false
                    }
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button {
                viewModel.showCreateBudgetSheet = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}
