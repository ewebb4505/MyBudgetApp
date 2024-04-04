//
//  BudgetDetailViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/26/24.
//

import Foundation

@Observable
class BudgetDetailViewModel {
    var budget: Budget
    var unassignedTransactions: [Transaction] = []
    var selectedTransactionsToAddToCategory: [Transaction] = []
    var budgetCategorySelected: BudgetCategory? = nil
    
    var showCreateBudgetCategoryView: Bool = false
    var showAddTransactionToBudgetCategoryView: Bool = false
    
    var createCategoryTitle: String = ""
    var createCategoryStartingAmount: String = ""
    
    private var budgetNetworkService: BudgetNetworkServiceProtocol = BudgetNetworkService(requestManager: RequestManager())
    private var budgetCategoryNetworkService: BudgetCategoryNetworkServiceProtocol = BudgetCategoryService(requestManager: RequestManager())
    private var transactionService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    private var tagsService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())
    
    init(budget: Budget) {
        self.budget = budget
    }
    
    func createBudgetCategory() async {
        guard !createCategoryTitle.isEmpty else {
            return
        }
        
        // TODO: add amount verification here
        guard !createCategoryStartingAmount.isEmpty, let startingAmount = Double(createCategoryStartingAmount) else {
            return
        }
        
        guard let result = await budgetCategoryNetworkService.createBudgetCategory(for: budget,
                                                                                   title: createCategoryTitle,
                                                                                   maxAmount: startingAmount) else {
            return
        }
        
        if budget.categories == nil {
            budget.categories = [result]
        } else {
            budget.categories?.append(result)
        }
    }
    
    func deleteBudget() async {}
    
    func fetchUnassignedTransactionsInBudgetDateRange() async {
        let results = await transactionService.getTransactions(fromDate: budget.startDate, toDate: budget.endDate, n: nil)
        var validTransactions: [Transaction] = []
        for transaction in results {
            guard let categories = budget.categories else {
                break
            }
            
            var transactionContainedByOtherCategory = false
            for category in categories {
                let categoryTransactions = await budgetCategoryNetworkService.getBudgetCategoryTransactions(id: category.id)
                if categoryTransactions.contains(where: { $0.id == transaction.id }) {
                    transactionContainedByOtherCategory = true
                }
            }
            
            if !transactionContainedByOtherCategory {
                validTransactions.append(transaction)
            }
        }
        unassignedTransactions = validTransactions
    }
    
    func assignTransactionToBudgetCategory() async {
        guard let budgetCategorySelected else {
            return
        }
        for transaction in selectedTransactionsToAddToCategory {
            let _ = await transactionService.addTransactionToCategory(transaction: transaction, category: budgetCategorySelected)
        }
        unassignedTransactions = []
        selectedTransactionsToAddToCategory = []
    }
    
    func getTotalSpentDuringBudget() {}
    
    func getBudgetCategoryTrackedTransactions(categoryID: BudgetCategory.ID) async -> [Transaction] {
        await budgetCategoryNetworkService.getBudgetCategoryTransactions(id: categoryID)
    }
}
