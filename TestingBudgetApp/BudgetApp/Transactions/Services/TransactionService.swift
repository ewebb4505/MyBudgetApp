//
//  TransactionService.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/4/23.
//

import Foundation

struct TransactionService {
    let requestManager: RequestManagerProtocol
}

extension TransactionService: TransactionsSearchable {
    func getTransactions(fromDate: Date?, toDate: Date?) async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(fromDate, toDate, nil)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          // 5
          print(error.localizedDescription)
          return []
        }
    }
    
    func getTransactions(onDate: Date?) async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(nil, nil, onDate)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          // 5
          print(error.localizedDescription)
          return []
        }
    }
    
    
    func getTransactions() async -> [Transaction] {
        let requestData = TransactionsRequest.getTransactions(nil, nil, nil)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          // 5
          print(error.localizedDescription)
          return []
        }
    }
    
    func createTransaction(title: String, amount: Double, date: Date) async -> Transaction? {
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


