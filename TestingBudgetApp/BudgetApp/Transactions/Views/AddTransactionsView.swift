//
//  AddTransactionsView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/1/23.
//

import Combine
import SwiftUI

@MainActor
struct AddTransactionsView: View {
    @StateObject var vm = AddTransactionViewModel()
    @FocusState var focus: AddTransactionViewModel.InputState?
    
    var body: some View {
        Form {
            TextField("Title", text: $vm.titleInput)
                .focused($focus, equals: AddTransactionViewModel.InputState.title)
            
            
            TextField("Amount", text: $vm.amountInput)
                .focused($focus, equals: AddTransactionViewModel.InputState.amount)
                .keyboardType(.numbersAndPunctuation)
                .onReceive(Just(vm.amountInput)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.vm.amountInput = filtered
                    }
                }
            
            Toggle(isOn: $vm.isExpense, label: {
                Text("Is Expense")
            })
            
            DatePicker("Date of Transaction", selection: $vm.dateInput, displayedComponents: .date)
                .focused($focus, equals: AddTransactionViewModel.InputState.date)
                .datePickerStyle(.automatic)
            
            Section {
                Button {
                    Task { await vm.addTransaction() }
                } label: {
                    Text("Submit Transaction")
                }
                .buttonStyle(.borderless)
            }
            
            if !vm.addedTransactions.isEmpty {
                Section("Added Transactions") {
                    List(vm.addedTransactions) { transaction in
                        Text(transaction.title)
                    }
                }
            }
                
        }
        .onSubmit {
            if focus == .title {
                focus = .amount
            } else if focus == .date {
                focus = .date
            }
        }
        
        .navigationTitle("Add Transaction")
    }
}
