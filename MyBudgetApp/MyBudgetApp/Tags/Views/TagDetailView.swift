//
//  TagDetailView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/13/24.
//

import SwiftUI

struct TagDetailView: View {
    let tag: Tag
    
    var body: some View {
        Text(tag.title)
    }
}
