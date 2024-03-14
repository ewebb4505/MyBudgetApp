//
//  TransactionsViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import Foundation
import RegexBuilder

@MainActor
final class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var tags: [Tag] = []
    
    // add transaction form properties
    @Published var transactionType: Int = 0
    @Published var transactionName: String = ""
    @Published var transactionAmount: String = ""
    @Published var transactionDate: Date = .now
    @Published var selectedTag: Tag? = nil
    
    @Published var loadingTransactions: Bool = false
    @Published var loadingTags: Bool = false
    @Published var errorCreatingNewTransaction: Bool = false
    @Published var shouldDismissNewTransactionView: Bool = false
    @Published var shouldReloadTransactionsData: Bool = false
    

    var appEnv = AppEnvironmentManager.instance
    private var network: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager())
    private var tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())
    
    func fetchTransactions() async {
        transactions = await network.getTransactions(n: 10)
        shouldReloadTransactionsData = false
    }
    
    func fetchTags() async {
        tags = await tagsNetworkService.getTags()
    }
    
    func submitNewTransaction() async {
        guard !transactionName.isEmpty, !nameContainsOnlyNumericAndSpecialCharacters() else {
            return
        }
        
        guard isUSDFormat(), let amount = Double(transactionAmount) else {
            return
        }
        
        let amountWithTwoDecimals = (amount * 100).rounded() / 100
        let signedAmount = transactionType == 0 ? -amountWithTwoDecimals : amountWithTwoDecimals
        guard let _ = await network.createTransaction(title: transactionName,
                                                      amount: signedAmount,
                                                      date: transactionDate,
                                                      tags: []) else {
            errorCreatingNewTransaction = true
            print("\n\n\n Error creating new transaction \n\n\n")
            return
        }
        
        print("\n\n\n Successfully created new transaction \n\n\n")
        shouldDismissNewTransactionView = true
        errorCreatingNewTransaction = false
        shouldReloadTransactionsData = true
    }
    
    private func nameContainsOnlyNumericAndSpecialCharacters() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[0-9\\W]+$", options: .caseInsensitive)
        return regex.firstMatch(in: transactionName, options: [], range: NSRange(location: 0, length: transactionName.utf16.count)) != nil
    }
    
    private func isUSDFormat() -> Bool {
        do {
            let dollarRegex = Regex(/^\d+(\.\d{2})?$/)
            let x = try dollarRegex.wholeMatch(in: transactionAmount) != nil
            return x
        } catch {
            return false
        }
    }
}
