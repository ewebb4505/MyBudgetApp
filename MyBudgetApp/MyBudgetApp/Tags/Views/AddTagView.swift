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
    var action: () async -> Void
    
    var body: some View {
        VStack {
            TextField("Tag Name", text: $tagName)
            Button {
                Task {
                    await action()
                }
            } label: {
                Text("Add Tag")
            }
            .buttonStyle(.borderedProminent)

        }
        .presentationDetents([.medium])
    }
}
