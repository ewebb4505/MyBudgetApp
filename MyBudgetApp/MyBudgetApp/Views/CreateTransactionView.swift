//
//  CreateTransactionView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import Combine
import SwiftUI

struct CreateTransactionView: View {
    var tags: [Tag]
    @StateObject var viewModel = CreateTransactionViewModel()
    @FocusState var focus: CreateTransactionViewModel.InputState?
    @State var selection: Int = 0
    
    var body: some View {
        VStack {
            Picker("Expense", selection: $selection) {
                Text("Expense").tag(0)
                Text("Income").tag(1)
            }
            .pickerStyle(.segmented)
            
            TextField("0.00", text: $viewModel.amountInput)
                .textFieldStyle(DollarAmountTextFieldStyle())
                .foregroundColor(selection == 0 ? .red : .green)
                .focused($focus, equals: CreateTransactionViewModel.InputState.amount)
                .keyboardType(.numbersAndPunctuation)
                .onReceive(Just(viewModel.amountInput)) { newValue in
                    let filtered = newValue.filter { "0123456789$".contains($0) }
                    if filtered != newValue {
                        self.viewModel.amountInput = filtered
                    }
                }
                .onSubmit {
                    viewModel.isValidTransaction()
                }
                .padding(.bottom, 32)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Transaction Title")
                    .font(.headline)
                TextField("Coffee w/ friends", text: $viewModel.titleInput)
                    .textFieldStyle(.roundedBorder)
                    .focused($focus, equals: CreateTransactionViewModel.InputState.title)
                    .onSubmit {
                        viewModel.isValidTransaction()
                    }
            }
            
            VStack(alignment: .leading) {
                Text("Tags")
                    .font(.headline)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(tags) { tag in
                            TagBadge(tag: tag) {
                                withAnimation {
                                    viewModel.handleTagTap(tag)
                                }
                            }
                            .isSelected(viewModel.tagIsSelected(tag))
                        }
                    }
                }
            }
            
            VStack {
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        Text("Create Transaction")
                        Spacer()
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.isValidSubmission)
            
            Spacer()
        }
        .onAppear(perform: {
            viewModel.isValidTransaction()
        })
        .padding()
    }
}


#Preview {
    CreateTransactionView(tags: [])
}
