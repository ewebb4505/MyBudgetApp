//
//  TagDetailViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/14/24.
//

import Foundation

@Observable
class TagDetailViewModel {
    let tag: Tag
    
    var totalSpending: Double = 0
    private(set) var tenMostRecentTransactions: [Transaction] = []
    
    private let tagNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())
    private let transactionsNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    
    init(tag: Tag) {
        self.tag = tag
    }
    
    @MainActor
    func getLastTenTransactionsForTag() async {
        tenMostRecentTransactions = await getLastNTransactionsForTag(n: 10)
        totalSpending = tenMostRecentTransactions.reduce(into: 0) { partialResult, transaction in
            partialResult += transaction.amount
        }
    }
    
    private func getLastNTransactionsForTag(n: Int) async -> [Transaction] {
        await tagNetworkService.getTransactions(tag: tag.id, n: n)
    }
}
