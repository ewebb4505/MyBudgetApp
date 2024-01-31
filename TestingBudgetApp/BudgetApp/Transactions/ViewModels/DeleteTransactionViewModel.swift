//
//  DeleteTransactionViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation

@MainActor
class DeleteTransactionViewModel: ObservableObject {
    @Published var errorWhenDeletingTransaction: Bool = false
    @Published var transactions: [Transaction] = []
    var transactionSearcher: TransactionsSearchable
    
    init(transactionSearcher: TransactionsSearchable = TransactionService(requestManager: RequestManager())) {
        self.transactionSearcher = transactionSearcher
    }
    
    func getAllTransactions() async -> Void {
        self.transactions = await transactionSearcher.getTransactions()
    }
    
    func deleteTransaction(_ id: UUID) async -> Void {
        let result = await transactionSearcher.deleteTransaction(id: id)
        errorWhenDeletingTransaction = !result
    }
}
