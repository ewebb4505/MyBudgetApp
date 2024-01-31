//
//  TagsServiceProtocol.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import Foundation

protocol TagsNetworkServiceProtocol {
    func getTags() async -> [Tag]
    func createTag(title: String) async -> Tag?
    func deleteTag(id: UUID) async -> Bool
}
