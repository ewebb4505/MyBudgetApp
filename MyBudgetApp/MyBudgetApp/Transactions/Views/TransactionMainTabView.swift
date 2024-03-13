//
//  TransactionMainTabView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct TransactionMainTabView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    @State private var showAddTransactionSheet: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack {
                TransactionsTableView(showAddTransactionSheet: $showAddTransactionSheet)
            }
            .onAppear {}
            .environmentObject(viewModel)
            .navigationTitle("Transactions")
            //.searchable(text: .constant(""))
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $showAddTransactionSheet) {
                AddTransactionView(transactionType: $viewModel.transactionType,
                                   transactionName: $viewModel.transactionName,
                                   transactionAmount: $viewModel.transactionAmount,
                                   shouldDismissNewTransactionView: $viewModel.shouldDismissNewTransactionView,
                                   shouldShowErrorCreatingNewTransaction: $viewModel.errorCreatingNewTransaction) { [weak viewModel] in
                    await viewModel?.submitNewTransaction()
                }
            }
            .onChange(of: viewModel.shouldDismissNewTransactionView) { oldValue, newValue in
                if newValue {
                    showAddTransactionSheet = false
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button {
                showAddTransactionSheet = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}

//#Preview {
//    TransactionMainTabView()
//}
