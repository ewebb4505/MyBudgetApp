//
//  TransactionsNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct TransactionsNetworkService: TransactionsNetworkServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    func getTransactions(fromDate: Date?, toDate: Date?, n: Int?) async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(fromDate, toDate, nil, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func getTransactions(onDate: Date?, n: Int?) async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(nil, nil, onDate, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    
    func getTransactions(n: Int?) async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(nil, nil, nil, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func createTransaction(title: String, amount: Double, date: Date, tags: [Tag]) async -> Transaction? {
        let requestData = TransactionsRequest.createTransactions(title, amount, date)
        do {
            let transaction: Transaction = try await requestManager.perform(requestData)
            return transaction
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteTransaction(id: UUID) async -> Bool {
        let requestData = TransactionsRequest.deleteTransaction(id)
        do {
            try await requestManager.performWithNoParsing(requestData)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func addTagsToTransaction(transaction: Transaction, tags: [Tag]) async -> Transaction? {
        let requestData = TransactionsRequest.addTagsToTransaction(transactionID: transaction.id, tagIDs: tags.map{ $0.id })
        do {
            let transaction: Transaction = try await requestManager.perform(requestData)
            return transaction
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func addTransactionToCategory(transaction: Transaction,
                                  category: BudgetCategory) async -> Transaction? {
        let requestData = TransactionsRequest.addTransactionToBudgetCategory(transactionID: transaction.id, categoryID: category.id)
        do {
            let transaction: Transaction = try await requestManager.perform(requestData)
            return transaction
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

