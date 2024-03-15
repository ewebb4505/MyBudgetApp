//
//  TagsMainTabViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import Foundation

@MainActor
final class TagsMainTabViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    @Published var tagToBeDeleted: Tag? = nil
    @Published var newTagTitle: String = ""
    @Published var loadingNewTag: Bool = false
    @Published var errorCreatingTag: Bool = false
    @Published var errorDeletingTag: Bool = false
    @Published var shouldReloadTags: Bool = false
    @Published var showAddTagSheet: Bool = false
    @Published var shouldDismissAddNewTagSheet: Bool = false
    
    private let tagsNetworkService: TagsNetworkServiceProtocol
    
    init(tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.tagsNetworkService = tagsNetworkService
    }
    
    func fetchTags() async {
        tags = await tagsNetworkService.getTags()
        shouldReloadTags = false
    }
    
    func createTag() async {
        loadingNewTag = true
        guard !newTagTitle.isEmpty else {
            loadingNewTag = false
           return
        }
        
        guard let _ = await tagsNetworkService.createTag(title: newTagTitle) else {
            errorCreatingTag = true
            loadingNewTag = false
            return
        }
        
        errorCreatingTag = false
        loadingNewTag = false
        shouldDismissAddNewTagSheet = true
    }
    
    func deleteTag() async {
        guard let id = tagToBeDeleted?.id else {
            return
        }
        
        if await tagsNetworkService.deleteTag(id: id) {
            errorDeletingTag = false
        } else {
            errorDeletingTag = true
            shouldReloadTags = true
        }
    }
}
