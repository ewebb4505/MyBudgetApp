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
    var totalSpentDuringBudget: Double = 0
    
    var showCreateBudgetCategoryView: Bool = false
    
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
        
    }
    func deleteBudget() async {}
    func fetchUnassignedTransactionsInBudgetDateRange() async {}
    func assignTransactionToBudgetCategory() async {}
    func getTotalSpentDuringBudget() {}
}
