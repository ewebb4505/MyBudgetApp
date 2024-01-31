//
//  AddTransactionToBudgetCategoryViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 11/8/23.
//

import Foundation

@MainActor
class AddTransactionToBudgetCategoryViewModel: ObservableObject {
    @Published var budgets: [Budget] = []
    @Published var transactionsInBudgetTimeline: [Transaction] = []
    
    var transactionSearcher: TransactionsSearchable
    var budgetSearcher: BudgetSearchable
    var budgetCategorySearcher: BudgetCategorySearchable
    
    // rename these props
    init(transactionService: TransactionsSearchable = TransactionService(requestManager: RequestManager()),
         budgetSearcher: BudgetSearchable = BudgetService(requestManager: RequestManager()),
         budgetCategorySearcher: BudgetCategorySearchable = BudgetCategoryService(requestManager: RequestManager())) {
        self.transactionSearcher = transactionService
        self.budgetSearcher = budgetSearcher
        self.budgetCategorySearcher = budgetCategorySearcher
    }
    
    func getBudgets() async {
        let results = await budgetSearcher.getBudgets()
        self.budgets = results
    }
    
    func addTransactionToBudgetCategory(transaction: Transaction, budgetCategory: BudgetCategory) async {
        let _ = await transactionSearcher.addTransactionToCategory(transaction: transaction,
                category: budgetCategory)
    }
    
    func getTransactionsInBudgetDateRange(_ budget: Budget) async {
        let fromDate = budget.startDate
        let toDate = budget.endDate
        let results = await transactionSearcher.getTransactions(fromDate: fromDate, toDate: toDate)
        transactionsInBudgetTimeline = results
    }
}
