//
//  TransactionsListView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import SwiftUI

@MainActor
struct TransactionsListView: View {
    enum AddTransactionField: Hashable {
        case title
        case amount
        case date
    }
    @StateObject var vm: TestingTransactionsViewModel = .init()
    @State var showAddTransactionSheet = false
    @State var titleTextFieldInput: String = ""
    @State var costTextFieldInput: String = ""
    @State var dateOfTransaction: Date = .now
    @FocusState private var focus: AddTransactionField?
    
    var body: some View {
        VStack {
            ForEach(vm.transactions) { transaction in
                HStack {
                    Text("\(transaction.title)")
                        .bold()
                    Text("\(transaction.amount)")
                        .fontWeight(.medium)
                    
                    Text("\(transaction.date.formatted(date: .numeric, time: .omitted))")
                        .fontWeight(.light)
                }
            }
            
            Spacer()
            
            Button {
                Task {
                    await vm.getAllTransactions()
                }
            } label: {
                Text("Get All Transactions From Server")
            }
            .buttonStyle(.borderedProminent)
        }
        .overlay {
            if vm.isLoadingResults {
                ProgressView()
            }
        }
        .transition(.opacity)
    }
}
