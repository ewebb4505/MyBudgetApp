//
//  CreateTransactionViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import Foundation

@MainActor
class CreateTransactionViewModel: ObservableObject {
    enum InputState: Hashable {
        case title, amount, date
    }
    
    @Published var titleInput: String = ""
    @Published var amountInput: String = ""
    @Published var dateInput: Date = .now
    @Published var isExpense: Bool = true
    
    @Published var addedTransactions: [Transaction] = []
    @Published var isLoading: Bool = false
    @Published var errorProcessingRequest: Bool = false
    @Published var tags: [Tag] = []
    @Published var selectedTagsForTransaction: [Tag] = []
    @Published var isValidSubmission: Bool = false
    
    var transactionNetworkService: TransactionsNetworkServiceProtocol
    var tagsNetworkService: TagsNetworkServiceProtocol
    
    init(tags: [Tag],
         transactionNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager()),
         tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.tags = tags
        self.transactionNetworkService = transactionNetworkService
        self.tagsNetworkService = tagsNetworkService
    }
    
    init(transactionNetworkService: TransactionsNetworkServiceProtocol = TransactionsNetworkService(requestManager: RequestManager()), tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.transactionNetworkService = transactionNetworkService
        self.tagsNetworkService = tagsNetworkService
    }
    
    func addTransaction() async {
        guard let amount = Double((isExpense ? "-" + amountInput : amountInput)) else {
            return
        }
        let result = await transactionNetworkService.createTransaction(title: titleInput, 
                                                                       amount: amount,
                                                                       date: dateInput, 
                                                                       tags: tags)
        if let transaction = result {
            addedTransactions.append(transaction)
        } else {
            errorProcessingRequest = true
        }
    }
    
    func handleTagTap(_ tag: Tag) {
        if !tagIsSelected(tag) {
            addTagToSelectedTags(tag)
        } else {
            removeTagFromSelectedTags(tag)
        }
    }
    
    func tagIsSelected(_ tag: Tag) -> Bool {
        selectedTagsForTransaction.contains(where: { $0.id == tag.id })
    }
    
    func isValidTransaction() {
        isValidSubmission = !titleInput.isEmpty && !amountInput.isEmpty
    }
    
    private func removeTagFromSelectedTags(_ tag: Tag) {
        selectedTagsForTransaction.removeAll(where: { $0.id == tag.id })
    }
    
    private func addTagToSelectedTags(_ tag: Tag) {
        selectedTagsForTransaction.append(tag)
    }
}
