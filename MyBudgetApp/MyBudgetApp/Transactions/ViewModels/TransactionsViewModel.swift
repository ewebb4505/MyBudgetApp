//
//  TransactionsViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import Foundation

final class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    var appEnv = AppEnvironmentManager.instance
    var network: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    
    func fetchTransactions() async {
        transactions = await network.getTransactions(n: 10)
    }
}
