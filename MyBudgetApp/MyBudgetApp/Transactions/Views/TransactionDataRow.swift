//
//  TransactionDataRow.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/12/23.
//

import SwiftUI

struct TransactionDataRow: View {
    var transcation: Transaction
    var showTags: Bool = false
    
    private var transactionAmount: Text {
        let amount = transcation.amount
        return Text("$\(String(format: "%.2f", abs(transcation.amount)))")
            .foregroundStyle(amount > 0 ? .green : .red)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                transactionDetails
                
                Spacer()
                
                transactionAmount
            }
            
            if let tags = transcation.tags, !tags.isEmpty {
                HStack(spacing: 2) {
                    Text("Tags: ")
                        .bold()
                        .font(.subheadline)
                    ForEach(tags) { tag in
                        Text(tag.title)
                            .bold()
                            .font(.subheadline)
                    }
                }
            }
        }
        .padding(4)
    }
    
    private var transactionDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(transcation.title)
                .font(.subheadline)
            
            Text(transcation.date.formatted(date: .abbreviated, time: .omitted))
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    private var transactionsDetailsWithTags: some View {
        if showTags {
            VStack {
                transactionDetails
                
                HStack(spacing: 4) {
                    ForEach(transcation.tags ?? []) { tag in
                        TagBadge(tag: tag)
                    }
                }
            }
        } else {
            transactionDetails
        }
    }
}

#Preview {
    TransactionDataRow(transcation: Transaction(id: .init(), title: "Coffee with friends", amount: 12.41, date: .now))
}
