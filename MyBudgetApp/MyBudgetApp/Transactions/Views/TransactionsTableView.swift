//
//  TransactionsTableView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct TransactionsTableView: View {
    @EnvironmentObject var viewModel: TransactionsViewModel

    // TODO: Implement grouping view
    enum GroupBy {
        case none
        case day
        case week
        case month
    }
    
    var body: some View {
        List(viewModel.transactions, id: \.id) { transaction in
            TransactionDataRow(transcation: transaction)
        }
    }
}

#Preview {
    TransactionsTableView()
}
