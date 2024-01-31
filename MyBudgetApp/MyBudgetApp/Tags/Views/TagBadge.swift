//
//  TagBadge.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

struct TagBadge: View {
    @Environment(\.isSelected) private var isSelected
    var tag: Tag
    var onTap: (() -> Void)?
    
    var body: some View {
        if isSelected {
            HStack {
                Text(tag.title)
                Image(systemName: "checkmark.circle.fill")
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 10)
            .background(.green.opacity(0.15))
            .clipShape(Capsule())
            .onTapGesture {
                if let onTap {
                    onTap()
                }
            }
        } else {
            Text(tag.title)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(.green.opacity(0.15))
                .clipShape(Capsule())
                .onTapGesture {
                    if let onTap {
                        onTap()
                    }
                }
        }
    }
}

#Preview {
    TagBadge(tag: Tag(id: .init(), title: "Coffee"))
}
