//
//  AddTagsToTransactionViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/10/23.
//

import Foundation

@MainActor
class AddTagsToTransactionViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var transactions: [Transaction] = []
    @Published var transactionWithNewTags: Transaction? = nil
    
    var error: Bool = false
    var tagsToAdd: [Tag] = []
    var selectedTransaction: Transaction?
    
    var transactionService: TransactionsSearchable
    var tagService: TagSearchable
    
    init(transactionService: TransactionsSearchable = TransactionService(requestManager: RequestManager()),
         tagService: TagSearchable = TagService(requestManager: RequestManager())) {
        self.transactionService = transactionService
        self.tagService = tagService
    }
    
    func getTransactions() async {
        transactions = await transactionService.getTransactions()
    }
    
    func getTags() async {
        tags = await tagService.getTags()
    }
    
    func addTagsToTransaction() async {
        guard let selectedTransaction else {
            return
        }
        transactionWithNewTags = await transactionService.addTagsToTransaction(transaction: selectedTransaction, tags: tagsToAdd)
    }
}
