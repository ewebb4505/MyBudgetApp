//
//  CurrentBudgetCardView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

struct CurrentBudgetCardView: View {
    var budget: Budget
    var amountSpent: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleView
            
            progressView
            
            categoriesScrollView
        }
        .padding(16)
        .frame(width: 360)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var titleView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(budget.title)
                    .font(.title3)
                    .foregroundStyle(.primary)
                
                Text("\(budget.startDate.formatted(date: .abbreviated, time: .omitted)) → \(budget.endDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    var progressView: some View {
        VStack {
            HStack {
                Text("$\(String(format: "%.2f", amountSpent))")
                    .font(.subheadline)
                
                Spacer()
                
                Text("$\(String(format: "%.2f", budget.startingAmount))")
                    .font(.subheadline)
            }
            ProgressView(value: 10.0, total: 100.0)
        }
    }
    
    @ViewBuilder
    var categoriesScrollView: some View {
        if !budget.categories.isEmpty {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(budget.categories) { category in
                        Text(category.title)
                    }
                }
            }
        }
    }
}

#Preview {
    CurrentBudgetCardView(budget: Budget(id: .init(), title: "Monthly Budget", startDate: .now, endDate: Date(timeInterval: 2600000, since: .now), startingAmount: 4000.0, categories: []), amountSpent: 1234)
}
