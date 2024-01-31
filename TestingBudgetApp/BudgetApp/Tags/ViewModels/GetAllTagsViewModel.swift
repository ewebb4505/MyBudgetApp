//
//  GetAllTagsViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

@MainActor
class GetAllTagsViewModel: ObservableObject {
    @Published var isLoadingResults: Bool = false
    @Published var tags: [Tag] = []
    
    var service: TagSearchable
    
    init(service: TagSearchable = TagService(requestManager: RequestManager())) {
        self.service = service
    }
    
    func getTags() async {
        isLoadingResults = true
        let results = await service.getTags()
        self.tags = results
        isLoadingResults = false
    }
}
