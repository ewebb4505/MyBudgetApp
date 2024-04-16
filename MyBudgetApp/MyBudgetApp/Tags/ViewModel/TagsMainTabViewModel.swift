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
        print(tags)
    }
    
    func createTag() async -> Tag? {
        loadingNewTag = true
        guard !newTagTitle.isEmpty else {
            loadingNewTag = false
           return nil
        }
        
        guard let tag = await tagsNetworkService.createTag(title: newTagTitle) else {
            errorCreatingTag = true
            loadingNewTag = false
            return nil
        }
        
        errorCreatingTag = false
        loadingNewTag = false
        shouldDismissAddNewTagSheet = true
        return tag
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
