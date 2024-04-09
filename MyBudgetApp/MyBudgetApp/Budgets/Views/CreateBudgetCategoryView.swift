//
//  CreateBudgetCategoryView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/26/24.
//

import SwiftUI

struct CreateBudgetCategoryView: View {
    @Binding var categoryTitle: String
    @Binding var categoryStartingAmount: String
    @FocusState var textfieldFocused: Bool
    var action: () async -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $categoryTitle)
                
                TextField("Spending Limit", text: $categoryStartingAmount)
                    .focused($textfieldFocused)
                    .keyboardType(.numbersAndPunctuation)
                    .onLongPressGesture(minimumDuration: 0.0) {
                        textfieldFocused = true
                    }
                    .autocorrectionDisabled()
                
                Section {
                    Button {
                        Task { await action() }
                    } label: {
                        Text("Create Category")
                    }
                    .buttonStyle(.borderless)
                }
            }
            .navigationTitle("Create Category")
        }
    }
}
