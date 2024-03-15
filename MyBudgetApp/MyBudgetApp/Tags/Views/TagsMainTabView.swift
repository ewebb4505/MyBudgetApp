//
//  TagsMainTabView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import SwiftUI

struct TagsMainTabView: View {
    @ObservedObject var viewModel: TagsMainTabViewModel
    @State private var shouldShowAddTagSheet: Bool = false
    
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
            .sheet(isPresented: $shouldShowAddTagSheet) {
                AddTagView(tagName: $viewModel.newTagTitle,
                           isLoading: $viewModel.loadingNewTag,
                           errorLoading: $viewModel.errorCreatingTag,
                           shouldDismiss: $viewModel.shouldDismissAddNewTagSheet) { [weak viewModel] in
                    await viewModel?.createTag()
                }
            }
            .onChange(of: viewModel.shouldDismissAddNewTagSheet) { oldValue, newValue in
                if newValue {
                    shouldShowAddTagSheet = false
                }
            }
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            Button {
                shouldShowAddTagSheet = true
            } label: {
                Image(systemName: "plus.circle")
            }
        }
    }
}
