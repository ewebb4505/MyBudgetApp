//
//  AddTagView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import SwiftUI

struct AddTagView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tagName: String
    @Binding var isLoading: Bool
    @Binding var errorLoading: Bool
    @Binding var shouldDismiss: Bool
    var action: () async -> Void
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Tag Name", text: $tagName)
                    
                    if isLoading {
                        ProgressView()
                    } else {
                        Button {
                            Task {
                                await action()
                            }
                        } label: {
                            Text("Add Tag")
                        }.disabled(tagName == "")
                    }
                }
            }
            .navigationTitle("Add Tag")
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
