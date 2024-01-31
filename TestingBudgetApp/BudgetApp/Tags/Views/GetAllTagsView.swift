//
//  GetAllTagsView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import SwiftUI

struct GetAllTagsView: View {
    @StateObject var vm: GetAllTagsViewModel = .init()
    
    var body: some View {
        List(vm.tags) { tag in
            VStack(alignment: .leading, spacing: 4) {
                Text(tag.title)
                Text(tag.id.uuidString)
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
        }
        .onAppear(perform: {
            Task {
               await vm.getTags()
            }
        })
    }
}
