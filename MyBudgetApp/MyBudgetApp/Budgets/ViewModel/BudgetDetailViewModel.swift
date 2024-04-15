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
    var addCategoriesToCreateTransactionView: Bool = false
    var categoryForNewTransaction: BudgetCategory? = nil
    
    var createCategoryTitle: String = ""
    var createCategoryStartingAmount: String = ""
    
    //TODO: Add tags
    var createTransactionTitle: String = ""
    var createTransactionType: Int = 0
    var createTransactionName: String = ""
    var createTransactionAmount: String = ""
    var createTransactionDate: Date = .now
    var shouldShowErrorCreatingNewTransaction: Bool = false
    var shouldDismissCreateTransaction: Bool = false
    var selectedBudgetCategoryForTransaction: BudgetCategory? = nil
    
    var reloadBudgetData: Bool = false
    
    var newTransaction: Transaction? = nil
    
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
    
    func reloadBudgetData() async {
        guard let updatedBudget = await budgetNetworkService.getBudget(id: budget.id) else {
            // show an error that says something about the budget not updating
            return
        }
        budget = updatedBudget
    }
    
    func getBudgetCategoryTrackedTransactions(categoryID: BudgetCategory.ID) async -> [Transaction] {
        await budgetCategoryNetworkService.getBudgetCategoryTransactions(id: categoryID)
    }
    
    func submitNewTransaction() async {
        guard !createTransactionName.isEmpty, !nameContainsOnlyNumericAndSpecialCharacters() else {
            return
        }
        
        guard isUSDFormat(), let amount = Double(createTransactionAmount) else {
            return
        }
        
        let amountWithTwoDecimals = (amount * 100).rounded() / 100
        let signedAmount = createTransactionType == 0 ? -amountWithTwoDecimals : amountWithTwoDecimals
        
//        var addedTags: [Tag] = []
//        if let selectedTag {
//            addedTags = [selectedTag]
//        }
        
        guard let transaction = await transactionService.createTransaction(title: createTransactionName,
                                                                 amount: signedAmount,
                                                                 date: createTransactionDate,
                                                                 tags: []) else {
            shouldShowErrorCreatingNewTransaction = true
            print("\n\n\n Error creating new transaction \n\n\n")
            return
        }
        
        print("\n\n\n Successfully created new transaction \n\n\n")
        showAddTransactionToBudgetCategoryView = false
        shouldShowErrorCreatingNewTransaction = false
        newTransaction = transaction
    }
    
    func addNewTransactionToSelectedBudgetCategory() async {
        guard let selectedBudgetCategoryForTransaction, let newTransaction else {
            return
        }
        let _ = await transactionService.addTransactionToCategory(transaction: newTransaction,
                                                          category: selectedBudgetCategoryForTransaction)
    }
    
    private func nameContainsOnlyNumericAndSpecialCharacters() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9\\W]+$", options: .caseInsensitive)
        return regex.firstMatch(in: createTransactionName, options: [], range: NSRange(location: 0, length: createTransactionName.utf16.count)) != nil
    }
    
    private func isUSDFormat() -> Bool {
        do {
            let dollarRegex = Regex(/^\d+(\.\d{2})?$/)
            let x = try dollarRegex.wholeMatch(in: createTransactionAmount) != nil
            return x
        } catch {
            return false
        }
    }
}
