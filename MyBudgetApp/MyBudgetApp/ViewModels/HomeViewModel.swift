//
//  HomeViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Combine
import SwiftUI
import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentBudgets: [Budget] = []
    @Published var transactions: [Transaction] = []
    @Published var allTags: [Tag] = []
    
    @Published var isLoadingResults: Bool = false
    @Published var isErrorFromFetchingData: Bool = false
    @Published var showEmptyViewBeforeLogin: Bool = false
    
    var currentBudgetsTotalSpending: [Budget.ID: Double] = [:]
    
    let budgetNetworkService: BudgetNetworkServiceProtocol
    let transactionsNetworkService: TransactionsNetworkServiceProtocol
    let tagsNetworkService: TagsNetworkServiceProtocol
    
    //app state
    var appEnv = AppEnvironmentManager.instance
    
    init(budgetNetworkService: BudgetNetworkServiceProtocol = BudgetNetworkService(requestManager: RequestManager()), transactionsNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager()), tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.budgetNetworkService = budgetNetworkService
        self.transactionsNetworkService = transactionsNetworkService
        self.tagsNetworkService = tagsNetworkService
    }
    
    // preview init
    init(currentBudgets: [Budget] = [],
         transactions: [Transaction] = [],
         allTags: [Tag] = [],
         budgetNetworkService: BudgetNetworkServiceProtocol = BudgetNetworkService(requestManager: RequestManager()),
         transactionsNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager()),
         tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.currentBudgets = currentBudgets
        self.transactions = transactions
        self.allTags = allTags
        self.budgetNetworkService = budgetNetworkService
        self.transactionsNetworkService = transactionsNetworkService
        self.tagsNetworkService = tagsNetworkService
    }
    
    func onAppear() async {
        if appEnv.userIsSignedIn() {
            isLoadingResults = true
            await getLastTenTransactions()
            await getCurrentBudgets()
            await getAllTags()
            await getTotalSpendingForEachCurrentBudget()
            isLoadingResults = false
        } else {
            showEmptyViewBeforeLogin = true
        }
    }
    
    func getLastTenTransactions() async {
        let results = await transactionsNetworkService.getTransactions(n: 10)
        transactions = results
    }
    
    func getCurrentBudgets() async {
        let results = await budgetNetworkService.getBudgets(isActive: true)
        currentBudgets = results
    }
    
    func getAllTags() async {
        let results = await tagsNetworkService.getTags()
        allTags = results
    }
    
    //TODO: this following function should be apart of the budget response object and the logic should be in the get budget request
    func getTotalSpendingForEachCurrentBudget() async {
        var totalSpending: [Budget.ID: Double] = [:]
        await currentBudgets.asyncForEach { budget in
            let transactions = await transactionsNetworkService.getTransactions(fromDate: budget.startDate,
                                                                                toDate: budget.endDate,
                                                                                n: nil)
            var totalSpent: Double = transactions.reduce(0) { partialResult, transactions in
                partialResult + transactions.amount
            }
            
            totalSpending[budget.id] = totalSpent
        }
        currentBudgetsTotalSpending = totalSpending
    }
    
    func logoutUser() async {
        appEnv.removeUser()
    }
}

extension Sequence {
    func asyncForEach(
        _ operation: (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}
