//
//  AddTransactionToBudgetCategoryView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/27/24.
//

import SwiftUI

struct AddTransactionToBudgetCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(BudgetDetailViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.unassignedTransactions.isEmpty {
                    Text("Gathering Transactions")
                } else {
                    List {
                        Section {
                            ForEach(viewModel.unassignedTransactions) { transaction in
                                HStack {
                                    Text(transaction.title)
                                        .font(.body)
                                    Spacer()
                                    if !viewModel.selectedTransactionsToAddToCategory.contains(where: { $0.id == transaction.id }) {
                                        Image(systemName: "circle")
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    } else {
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.body)
                                            .foregroundColor(.blue)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    if viewModel.selectedTransactionsToAddToCategory.contains(where: { $0.id == transaction.id }) {
                                        if let result = viewModel.selectedTransactionsToAddToCategory.firstIndex(of: transaction) {
                                            viewModel.selectedTransactionsToAddToCategory.remove(at: result)
                                        }
                                    } else {
                                        viewModel.selectedTransactionsToAddToCategory.append(transaction)
                                    }
                                }
                            }
                        } header: {
                            Text("Available Transactions")
                        }
                    }
                }
            }
            .navigationTitle("Add Transaction for \(viewModel.budgetCategorySelected?.title ?? "")")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.visible, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .task {
                await viewModel.fetchUnassignedTransactionsInBudgetDateRange()
            }
        }
    }
}

#Preview {
    AddTransactionToBudgetCategoryView()
}
