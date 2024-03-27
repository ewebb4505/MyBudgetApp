//
//  TransactionsNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct TransactionsNetworkService: TransactionsNetworkServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    func getTransactions(fromDate: Date?, toDate: Date?, n: Int?) async -> Transactions {
        let requestData = TransactionsRequest.getTransactions(fromDate, toDate, nil, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func getTransactions(onDate: Date?, n: Int?) async -> Transactions {
        let requestData = TransactionsRequest.getTransactions(nil, nil, onDate, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    
    func getTransactions(n: Int?) async -> Transactions {
        let requestData = TransactionsRequest.getTransactions(nil, nil, nil, n)
        do {
          let transactions: [Transaction] = try await requestManager.perform(requestData)
          return transactions
        } catch {
          print(error.localizedDescription)
          return []
        }
    }
    
    func getTransactions(tag: Tag.ID) async -> Transactions {
        []
    }
    
    func getTransactions(tag: Tag.ID, n: Int) async -> Transactions {
        []
    }
    
    func getTransactions(tag: Tag.ID, fromDate: Date, toDate: Date) async -> Transactions {
        []
    }
    
    func createTransaction(title: String, amount: Double, date: Date, tags: [Tag]) async -> Transaction? {
        let requestData = TransactionsRequest.createTransactions(title,
                                                                 amount,
                                                                 date, tags.map({$0.id}))
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
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return nil
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return nil
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

