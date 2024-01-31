//
//  DeleteTransactionView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/4/23.
//

import SwiftUI

struct DeleteTransactionView: View {
    @StateObject var vm: DeleteTransactionViewModel = .init()
    var body: some View {
        List(vm.transactions) { transaction in
            HStack {
                VStack {
                    Text(transaction.title)
                        .font(.title3)
                    Text(transaction.amount.description)
                        .font(.subheadline)
                    Text("\(transaction.date.formatted(date: .numeric, time: .omitted))")
                        .font(.footnote)
                }
                
                Spacer()
                
                Button {
                    Task {
                        await vm.deleteTransaction(transaction.id)
                        if !vm.errorWhenDeletingTransaction {
                            await vm.getAllTransactions()
                        }
                    }
                } label: {
                    Text("Delete")
                }
                .tint(.red)
            }
        }
        .onAppear(perform: {
            Task {
                await vm.getAllTransactions()
            }
        })
    }
}
