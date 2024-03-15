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
    var tenMostRecentTransactions: [Transaction] = []
    
    private let tagNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())
    private let transactionsNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    
    init(tag: Tag) {
        self.tag = tag
    }
}
