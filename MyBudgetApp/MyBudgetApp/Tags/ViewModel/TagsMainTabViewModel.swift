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
    @Published var errorCreatingTag: Bool = false
    @Published var errorDeletingTag: Bool = false
    @Published var shouldReloadTags: Bool = false
    @Published var showAddTagSheet: Bool = false
    
    private let tagsNetworkService: TagsNetworkServiceProtocol
    
    init(tagsNetworkService: TagsNetworkServiceProtocol = TagsNetworkService(requestManager: RequestManager())) {
        self.tagsNetworkService = tagsNetworkService
    }
    
    func fetchTags() async {
        tags = await tagsNetworkService.getTags()
        shouldReloadTags = false
    }
    
    func createTag() async {
        guard !newTagTitle.isEmpty else {
           return
        }
        
        guard let tag = await tagsNetworkService.createTag(title: newTagTitle) else {
            errorCreatingTag = true
            return
        }
        
        errorCreatingTag = false
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
