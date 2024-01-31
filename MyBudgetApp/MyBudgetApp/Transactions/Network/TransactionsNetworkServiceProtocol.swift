//
//  TransactionsNetworkServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol TransactionsNetworkServiceProtocol {
    func getTransactions(n: Int?) async -> [Transaction]
    func getTransactions(fromDate: Date?, toDate: Date?, n: Int?) async -> [Transaction]
    func getTransactions(onDate: Date?, n: Int?) async -> [Transaction]
    func createTransaction(title: String, amount: Double, date: Date, tags: [Tag]) async -> Transaction?
    func deleteTransaction(id: UUID) async -> Bool
    func addTagsToTransaction(transaction: Transaction, tags: [Tag]) async -> Transaction?
    func addTransactionToCategory(transaction: Transaction, category: BudgetCategory) async -> Transaction?
}
