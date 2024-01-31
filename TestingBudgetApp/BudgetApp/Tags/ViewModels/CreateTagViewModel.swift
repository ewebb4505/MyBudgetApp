//
//  CreateTagViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

@MainActor
class CreateTagViewModel: ObservableObject {
    @Published var titleInput: String = ""
    @Published var addedTags: [Tag] = []
    @Published var errorProcessingRequest = false
    
    var service: TagSearchable
    
    init(service: TagSearchable = TagService(requestManager: RequestManager())) {
        self.service = service
    }
    
    func createTag() async {
        let result = await service.createTag(title: titleInput)
        if let tag = result {
            addedTags.append(tag)
        } else {
            errorProcessingRequest = true
        }
    }
}
