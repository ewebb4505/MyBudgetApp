//
//  AddTagsToTransactionView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/10/23.
//

import SwiftUI

struct AddTagsToTransactionView: View {
    @StateObject var vm = AddTagsToTransactionViewModel()
    @State var showSheet: Bool = false
    
    var body: some View {
        List(vm.transactions) { transaction in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(transaction.title)")
                        Group {
                            Text("\(transaction.amount)") +
                            Text(" - ") +
                            Text("\(transaction.date.formatted())")
                        }
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        vm.selectedTransaction = transaction
                        showSheet.toggle()
                    } label: {
                        Text("Add Tags")
                    }
                }
                
                if let tags = transaction.tags {
                    HStack {
                        ForEach(tags) { tag in
                            Text("\(tag.title)")
                                .foregroundStyle(.white)
                                .padding(8)
                                .background {
                                    Color.black
                                }
                                .clipShape(Capsule())
                        }
                    }
                }
            }
        }.onAppear(perform: {
            Task {
                await vm.getTransactions()
                await vm.getTags()
            }
        })
        .sheet(isPresented: $showSheet, content: {
            if vm.tags.isEmpty {
                Text("No Tags Available")
            } else {
                VStack {
                    Group {
                        Button {
                            Task {
                                await vm.addTagsToTransaction()
                            }
                        } label: {
                            Text("Add Selected Tags")
                        }

                    }
                    .padding(.vertical, 32)
                    List(vm.tags) { tag in
                        HStack {
                            Text("\(tag.title)")
                            Spacer()
                            Button {
                                if let transaction = vm.selectedTransaction,
                                    let tags = transaction.tags {
                                    if !tags.contains(where: { $0.id == tag.id }) {
                                        vm.tagsToAdd.append(tag)
                                    }
                                }
                            } label: {
                                if let transaction = vm.selectedTransaction, let tags = transaction.tags {
                                    Image(systemName: tags.contains(where: { $0.id == tag.id }) ? "checkmark.circle.fill" : "plus.circle")
                                } else {
                                    Text("WHAT HAPPENED?")
                                }
                                
                            }
                        }
                    }
                }
            }
        })
    }
}
