//
//  TransactionsTableView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct TransactionsTableView: View {
    @EnvironmentObject var viewModel: TransactionsViewModel
    @Binding var showAddTransactionSheet: Bool

    // TODO: Implement grouping view
    enum GroupBy {
        case none
        case day
        case week
        case month
    }
    
    var body: some View {
        if viewModel.transactions.isEmpty {
            VStack {
                Text("You have no tracked transactions! Add transactions to keep track of your spending habits and streams of income.")
                    .font(.title3)
                    .bold()
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button {
                    showAddTransactionSheet = true
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Add Transaction")
                        
                        Spacer()
                    }
                }
                .buttonBorderShape(.roundedRectangle(radius: 8))
                .controlSize(.extraLarge)
                .buttonStyle(.borderedProminent)
                .padding()
            }
        } else {
            List(viewModel.transactions, id: \.id) { transaction in
                TransactionDataRow(transcation: transaction)
            }
        }
    }
}

#Preview {
    TransactionsTableView(showAddTransactionSheet: .constant(false))
}
