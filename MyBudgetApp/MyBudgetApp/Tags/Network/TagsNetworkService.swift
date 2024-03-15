//
//  TagsNetworkService.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

struct TagsNetworkService: TagsNetworkServiceProtocol {
    let requestManager: RequestManagerProtocol
    
    func getTags() async -> Tags {
        let requestData = TagsRequest.getTags
        do {
            let tags: [Tag] = try await requestManager.perform(requestData)
            return tags
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getTransactions(tag: Tag.ID, n: Int) async -> Transactions {
        do {
            let transactions: Transactions = try await requestManager.perform(TagsRequest.getTransactions(tag, n, nil, nil))
            return transactions
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getTransactions(tag: Tag.ID, fromDate: Date?, toDate: Date?) async -> Transactions {
        do {
            let transactions: Transactions = try await requestManager.perform(TagsRequest.getTransactions(tag, -1, fromDate, toDate))
            return transactions
        } catch {
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
