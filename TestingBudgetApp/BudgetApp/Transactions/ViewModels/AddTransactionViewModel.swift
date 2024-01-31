//
//  AddTransactionViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/3/23.
//

import Foundation
import SwiftUI

@MainActor
class AddTransactionViewModel: ObservableObject {
    enum InputState: Hashable {
        case title, amount, date
    }
    
    @Published var titleInput: String = ""
    @Published var amountInput: String = ""
    @Published var dateInput: Date = .now
    @Published var isExpense: Bool = true
    
    @Published var addedTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorProcessingRequest: Bool = false

    var transactionSearcher: TransactionsSearchable
    
    init(transactionSearcher: TransactionsSearchable = TransactionService(requestManager: RequestManager())) {
        self.transactionSearcher = transactionSearcher
    }
    
    func addTransaction() async -> Void {
        guard let amount = Double((isExpense ? "-" + amountInput : amountInput)) else {
            return
        }
        let result = await transactionSearcher.createTransaction(title: titleInput, amount: amount, date: dateInput)
        if let transaction = result {
            addedTransactions.append(transaction)
        } else {
            errorProcessingRequest = true
        }
    }
}
