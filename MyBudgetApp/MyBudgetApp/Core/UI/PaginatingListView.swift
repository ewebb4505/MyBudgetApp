//
//  PaginatingListView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct PaginatingListView<T: Identifiable, ItemView: View>: View {
    var limit: Int
    @Binding var array: [T]
    var itemViewBuilder: (T) -> ItemView
    
    var body: some View {
        List(array, id: \.id) { item in
            itemViewBuilder(item)
            //TODO: add on appear method that gets called at the limit index
        }
    }
}
