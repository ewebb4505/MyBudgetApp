//
//  TagsServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol TagsNetworkServiceProtocol {
    typealias Transactions = [Transaction]
    typealias Tags = [Tag]
    
    func getTags() async -> Tags
    func getTransactions(tag: Tag.ID, n: Int) async -> Transactions
    func getTransactions(tag: Tag.ID, fromDate: Date?, toDate: Date?) async -> Transactions
    func createTag(title: String) async -> Tag?
    func deleteTag(id: UUID) async -> Bool
}
