//
//  TestingTransactionsViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import Foundation

@MainActor
class TestingTransactionsViewModel: ObservableObject {
    @Published var isLoadingResults: Bool = false
    @Published var transactions: [Transaction] = []
    
    var transactionSearcher: TransactionsSearchable
    
    init(transactionSearcher: TransactionsSearchable = TransactionService(requestManager: RequestManager())) {
        self.transactionSearcher = transactionSearcher
    }
    
    func getAllTransactions() async -> Void {
        isLoadingResults = true
        self.transactions = await transactionSearcher.getTransactions()
        isLoadingResults = false
    }
}
