//
//  TagSearchable.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/9/23.
//

import Foundation

protocol TagSearchable {
    func getTags() async -> [Tag]
    func createTag(title: String) async -> Tag?
    func deleteTag(id: UUID) async -> Bool
}
