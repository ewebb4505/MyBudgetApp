//
//  CheckCircleView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 4/8/24.
//

import SwiftUI

struct CheckCircleView: View {
    var isSelected: Bool
    
    var body: some View {
        if !isSelected {
            Image(systemName: "circle")
                .font(.body)
                .foregroundColor(.gray)
        } else {
            Image(systemName: "checkmark.circle.fill")
                .font(.body)
                .foregroundColor(.blue)
        }
    }
}
