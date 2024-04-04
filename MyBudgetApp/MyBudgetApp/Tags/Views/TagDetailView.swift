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
                List {
                    Section {
                        ForEach(viewModel.tenMostRecentTransactions) { transaction in
                            TransactionDataRow(transcation: transaction)
                        }
                    } header: {
                        HStack {
                            Text("Last 10 transactions")
                            Spacer()
                            viewModel.totalSpending.displayColoredUSD()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.getLastTenTransactionsForTag()
        }
        .navigationTitle(viewModel.tag.title)
    }
}

extension Double {
    func displayColoredUSD() -> Text {
        Text("$\(String(format: "%.2f", abs(self)))")
            .foregroundStyle(self > 0 ? .green : .red)
    }
    
    func displayUSD() -> Text {
        Text("$\(String(format: "%.2f", abs(self)))")
    }
}
