//
//  TagDetailView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import SwiftUI

struct TagDetailView: View {
    let viewModel: TagDetailViewModel
    
    init(tag: Tag) {
        self.viewModel = TagDetailViewModel(tag: tag)
    }
    
    var body: some View {
        VStack {
            if viewModel.tenMostRecentTransactions.isEmpty {
                Text("This Tag has no transactions")
            } else {
                ForEach(viewModel.tenMostRecentTransactions) { transaction in
                    Text(transaction.title)
                }
            }
        }
        .task {
            await viewModel.getLastTenTransactionsForTag()
        }
    }
}
