//
//  TransactionMainTabView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct TransactionMainTabView: View {
    @ObservedObject var viewModel: TransactionsViewModel
    
    var body: some View {
        VStack {
            TransactionsTableView()
        }
        .onAppear {
            
        }
        .environmentObject(viewModel)
        .navigationTitle("Transactions")
        .searchable(text: .constant(""))
        .toolbar {
            toolbarContent
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button {
                
            } label: {
                Image("plus")
            }
        }
    }
}

//#Preview {
//    TransactionMainTabView()
//}
