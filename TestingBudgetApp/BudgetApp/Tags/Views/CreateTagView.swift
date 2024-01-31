//
//  CreateTagView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import SwiftUI

@MainActor
struct CreateTagView: View {
    @StateObject var vm = CreateTagViewModel()
    
    var body: some View {
        Form {
            TextField("Tag Title", text: $vm.titleInput)
            Button {
                Task {
                    await vm.createTag()
                }
            } label: {
                Text("Create Tag")
            }
            
            Section {
                ForEach(vm.addedTags) { tag in
                    Text("\(tag.title)")
                }
            }
        }
    }
}

