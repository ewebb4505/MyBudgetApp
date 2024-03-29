//
//  BudgetDetailView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/26/24.
//

import SwiftUI
import Charts

struct BudgetDetailView: View {
    @Bindable var viewModel: BudgetDetailViewModel
    
    init(budget: Budget) {
        viewModel = BudgetDetailViewModel(budget: budget)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                headerView
                
                pieChartForBudget
                
                Divider()
            
                categoriesView
                
                Spacer()
                
                bottomButtonsView
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .sheet(isPresented: $viewModel.showCreateBudgetCategoryView) {
                CreateBudgetCategoryView(categoryTitle: $viewModel.createCategoryTitle,
                                         categoryStartingAmount: $viewModel.createCategoryStartingAmount) {
                    await viewModel.createBudgetCategory()
                }
            }
            .sheet(isPresented: $viewModel.showAddTransactionToBudgetCategoryView, onDismiss: {
                Task {
                    await viewModel.assignTransactionToBudgetCategory()
                }
            }) {
                AddTransactionToBudgetCategoryView()
                    .environment(viewModel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var headerView: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(viewModel.budget.title)
                    .font(.title)
                HStack(spacing: 2) {
                    Group {
                        Text(viewModel.budget.startDate.formatted(date: .abbreviated, time: .omitted))
                        Text("→")
                        Text(viewModel.budget.endDate.formatted(date: .abbreviated, time: .omitted))
                    }
                    .font(.body.weight(.light))
                }
            }
            
            Spacer()
            
            viewModel.totalSpentDuringBudget.displayColoredUSD()
        }
    }
    
    private var bottomButtonsView: some View {
        VStack {
            Divider()
            HStack {
                Button {
                    viewModel.showCreateBudgetCategoryView = true
                } label: {
                    HStack {
                        Spacer()
                        Text("Create Category")
                            .bold()
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                .controlSize(.large)
                .buttonStyle(.bordered)
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Add Transaction")
                            .bold()
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        Spacer()
                    }
                }
                .controlSize(.large)
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    @ViewBuilder
    private var categoriesView: some View {
        if let categories = viewModel.budget.categories, !categories.isEmpty {
            VStack(alignment: .leading) {
                Text("Budget Categories")
                    .bold()
                ForEach(categories) { category in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(category.title)
                            Text("Limit: \(category.maxAmount)")
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.budgetCategorySelected = category
                            viewModel.showAddTransactionToBudgetCategoryView = true
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Transaction")
                            }
                        }

                    }
                    .padding()
                }
            }
        }
    }
    
    @ViewBuilder
    private var pieChartForBudget: some View {
        if let categories = viewModel.budget.categories, !categories.isEmpty {
            Chart(categories) { category in
                SectorMark(
                    angle: .value(
                        Text(verbatim: category.title),
                        10
                    )
                )
                .foregroundStyle(
                    by: .value(
                        Text(verbatim: category.title),
                        category.title
                    )
                )
            }
        }
    }
}
