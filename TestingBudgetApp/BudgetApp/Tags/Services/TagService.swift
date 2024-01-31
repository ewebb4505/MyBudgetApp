//
//  TagService.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

struct TagService: TagSearchable {
    let requestManager: RequestManagerProtocol
    
    func getTags() async -> [Tag] {
        let requestData = TagsRequest.getTags
        do {
          let tags: [Tag] = try await requestManager.perform(requestData)
          return tags
        } catch {
          // 5
          print(error.localizedDescription)
          return []
        }
    }
    
    func createTag(title: String) async -> Tag? {
        let requestData = TagsRequest.createTag(title)
        do {
            let tag: Tag = try await requestManager.perform(requestData)
            return tag
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteTag(id: UUID) async -> Bool {
        let requestData = TagsRequest.deleteTag(id)
        do {
            try await requestManager.performWithNoParsing(requestData)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

//extension TransactionService: TransactionsSearchable {
//    func getTransactions() async -> [Transaction] {
//        let requestData = TransactionsRequest.getTransactions
//        do {
//          let transactions: [Transaction] = try await requestManager.perform(requestData)
//          return transactions
//        } catch {
//          // 5
//          print(error.localizedDescription)
//          return []
//        }
//    }
//    
//    func createTransaction(title: String, amount: Double, date: Date) async -> Transaction? {
//        let requestData = TransactionsRequest.createTransactions(title, amount, date)
//        do {
//            let transaction: Transaction = try await requestManager.perform(requestData)
//            return transaction
//        } catch {
//            print(error.localizedDescription)
//            return nil
//        }
//    }
//    
//    func deleteTransaction(id: UUID) async -> Bool {
//        let requestData = TransactionsRequest.deleteTransaction(id)
//        do {
//            try await requestManager.performWithNoParsing(requestData)
//            return true
//        } catch {
//            print(error.localizedDescription)
//            return false
//        }
//    }
//}
