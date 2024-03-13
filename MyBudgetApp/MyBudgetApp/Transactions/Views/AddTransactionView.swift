//
//  AddTransactionView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/26/24.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var transactionType: Int
    @Binding var transactionName: String
    @Binding var transactionAmount: String
    @Binding var shouldDismissNewTransactionView: Bool
    @Binding var shouldShowErrorCreatingNewTransaction: Bool
    
    let submitAction: () async -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Expense", selection: $transactionType) {
                        Text("Expense").tag(0)
                        Text("Income").tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Name", text: $transactionName)
                    
                    TextField("Amount", text: $transactionAmount)
                }
                
                Section {
                    Button {
                        Task {
                            await submitAction()
                        }
                    } label: {
                        Text("Submit")
                    }
                }
                
                if shouldShowErrorCreatingNewTransaction {
                    Section {
                        Text("error trying to create new transaction. try again")
                            .font(.title3)
                            .foregroundStyle(.red)
                    }
                }
            }
            .onAppear {
                shouldDismissNewTransactionView = false
            }
            .navigationTitle("Add Transaction")
            .toolbar(.visible, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    .foregroundColor(Color.gray)
                }
            }
        }
    }
}
