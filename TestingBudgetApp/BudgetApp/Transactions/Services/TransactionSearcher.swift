//
//  TransactionSearcher.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

protocol TransactionsSearchable {
    func getTransactions() async -> [Transaction]
    func getTransactions(fromDate: Date?, toDate: Date?) async -> [Transaction]
    func getTransactions(onDate: Date?) async -> [Transaction]
    func createTransaction(title: String, amount: Double, date: Date) async -> Transaction?
    func deleteTransaction(id: UUID) async -> Bool
    func addTagsToTransaction(transaction: Transaction, tags: [Tag]) async -> Transaction?
    func addTransactionToCategory(transaction: Transaction, category: BudgetCategory) async -> Transaction?
}
