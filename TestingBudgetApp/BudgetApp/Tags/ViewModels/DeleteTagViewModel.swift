//
//  DeleteTagViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

@MainActor
class DeleteTagViewModel: ObservableObject {
    @Published var tags: [Tag] = []
    var service: TagSearchable
    
    init(service: TagSearchable = TagService(requestManager: RequestManager())) {
        self.service = service
    }
    
    func getTags() async {
        tags = await service.getTags()
    }
    
    func deleteTag(_ id: UUID) async {
        let _ = await service.deleteTag(id: id)
        await getTags()
    }
}
