//
//  TranscationDetailViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/24/24.
//

import Foundation

@Observable
class TranscationDetailViewModel {
    var transaction: Transaction
    
    private var network: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    func addTagToThisTransaction() async {
        // pass
    }
    
    func deleteThisTransaction() async {
        // pass
    }
}
