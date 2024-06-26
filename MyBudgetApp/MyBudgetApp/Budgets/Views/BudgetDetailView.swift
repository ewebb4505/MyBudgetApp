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
    let isActive: Bool
    
    init(budget: Budget, isActive: Bool) {
        viewModel = BudgetDetailViewModel(budget: budget)
        self.isActive = isActive
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            List {
                Section {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 2) {
                            Group {
                                Text(viewModel.budget.startDate.formatted(date: .abbreviated, time: .omitted))
                                Text("→")
                                Text(viewModel.budget.endDate.formatted(date: .abbreviated, time: .omitted))
                            }
                            .font(.body.weight(.light))
                        }
                        
                        viewModel.budget.totalSpent.displayColoredUSD()
                            .font(.body.weight(.bold))
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listSectionSeparatorTint(.clear)
                .background(.clear)
                
                if let categories = viewModel.budget.categories, !categories.isEmpty {
                    Section {
                        pieChartForBudget
                    } header: {
                        Text("Budget Breakdown")
                    }
                    
                    Section {
                        categoriesView
                    } header: {
                        Text("Categories")
                    }
                }
                
                // trick for adding spacing at the bottom of the List
                Color(.clear)
                    .listRowBackground(Color.clear)
                    .listSectionSeparatorTint(.clear)
                    .frame(height: 50)
            }
            .listSectionSpacing(.compact)
            .overlay {
                if viewModel.budget.categories?.isEmpty ?? false {
                    Text("You aren't tracking any transactions for this budget.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            
            if isActive {
                bottomButtonsView
                    .background(.white)
            }
        }
        .sheet(isPresented: $viewModel.showCreateBudgetCategoryView) {
            CreateBudgetCategoryView(categoryTitle: $viewModel.createCategoryTitle,
                                     categoryStartingAmount: $viewModel.createCategoryStartingAmount) {
                await viewModel.createBudgetCategory()
            }
        }
        .sheet(isPresented: $viewModel.showAddTransactionToBudgetCategoryView, content: {
            let categories = viewModel.addCategoriesToCreateTransactionView ? viewModel.budget.categories : nil
            AddTransactionView(tags: [],
                               budgetCategories: categories,
                               selectedCategory: $viewModel.selectedBudgetCategoryForTransaction,
                               transactionType: $viewModel.createTransactionType,
                               transactionName: $viewModel.createTransactionName,
                               transactionAmount: $viewModel.createTransactionAmount,
                               transactionDate: $viewModel.createTransactionDate,
                               selectedTag: .constant(nil),
                               shouldDismissNewTransactionView: $viewModel.shouldDismissCreateTransaction,
                               shouldShowErrorCreatingNewTransaction: $viewModel.shouldShowErrorCreatingNewTransaction) {
                await viewModel.submitNewTransaction()
                await viewModel.addNewTransactionToSelectedBudgetCategory()
                await viewModel.reloadBudgetData()
            }
        })
        .navigationTitle(viewModel.budget.title)
        .navigationDestination(for: BudgetCategory.self) { budgetCategory in
            CategoryDetailView(category: budgetCategory, isActive: isActive)
                .environment(viewModel)
        }
        .onChange(of: viewModel.reloadBudgetData) { oldValue, newValue in
            if newValue {
                
            }
        }
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
        }
    }
    
    private var bottomButtonsView: some View {
        VStack(spacing: 0) {
            Divider()
                .frame(height: 1)
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
                    viewModel.addCategoriesToCreateTransactionView = true
                    viewModel.showAddTransactionToBudgetCategoryView = true
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
            .padding()
        }
    }
    
    @ViewBuilder
    private var categoriesView: some View {
        if let categories = viewModel.budget.categories, !categories.isEmpty {
            ForEach(categories) { category in
                NavigationLink(value: category) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(category.title)
                            Group {
                                Text("Spent ")
                                + category.totalAmountSpent.displayUSD()
                                + Text(" out of ")
                                + category.maxAmount.displayUSD()
                            }
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                    }
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
                        category.totalAmountSpent
                    )
                )
                .foregroundStyle(
                    by: .value(
                        Text(verbatim: category.title),
                        category.title
                    )
                )
            }
            .frame(height: 200)
        }
    }
}
