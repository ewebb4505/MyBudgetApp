//
//  TagsMainTabView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import SwiftUI

struct TagsMainTabView: View {
    @ObservedObject var viewModel: TagsMainTabViewModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.tags) { tag in
                    NavigationLink(value: tag) {
                        HStack {
                            Text(tag.title)
                            
                            Spacer()
                            
                            Image(systemName: "info.circle")
                        }
                    }
                }
            }
            .onAppear(perform: {
                Task {
                    await viewModel.fetchTags()
                }
            })
            .navigationDestination(for: Tag.self) { tag in
                TagDetailView(tag: tag)
            }
            .navigationTitle("Tags")
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $viewModel.showAddTagSheet) {
                AddTagView(tagName: $viewModel.newTagTitle) { [weak viewModel] in
                    await viewModel?.createTag()
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button {
                viewModel.showAddTagSheet = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}
