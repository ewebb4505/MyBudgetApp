//
//  DeleteTagView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import SwiftUI

struct DeleteTagView: View {
    @StateObject var vm = DeleteTagViewModel()
    
    var body: some View {
        List(vm.tags) { tag in
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(tag.title)
                        Text(tag.id.uuidString)
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await vm.deleteTag(tag.id)
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    .tint(.red)
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .onAppear(perform: {
            Task {
               await vm.getTags()
            }
        })
    }
}
