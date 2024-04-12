//
//  LoggedInHomeView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import Charts
import SwiftUI

struct LoggedInHomeView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    @Binding var showingFullScreenCover: Bool
    
    var body: some View {
        ZStack {
            List {
                Section {
                    currentBudgetStats
                } header: {
                    Text("Current Budget")
                }
                
                Section {
                    mostUsedTagsBarChart
                } header: {
                    Text("5 most used tags")
                }
                
                if !viewModel.transactions.isEmpty {
                    Section {
                        ForEach(Array<Transaction>(viewModel.transactions[0..<5])) { transaction in
                            TransactionDataRow(transcation: transaction)
                        }
                    } header: {
                        Text("5 most recent transactions")
                    }
                }
            }
        }
    }
    
    // new subviews
    
    @ViewBuilder
    private var currentBudgetStats: some View {
        if !viewModel.currentBudgets.isEmpty, let budget = viewModel.currentBudgets.first {
            if let categories = budget.categories {
                Chart(categories) { category in
                    //ForEach(categories) {
                        if category.totalAmountSpent < 0 {
                            SectorMark(angle: .value("Spent", -category.totalAmountSpent),
                                       innerRadius: .ratio(0.6),
                                       angularInset: 2.0)
                            .cornerRadius(4)
                            .foregroundStyle(by: .value("Type", category.title))
                            .annotation(position: .overlay, alignment: .center) {
                                category.totalAmountSpent.displayUSD()
                                    .font(.caption)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                .frame(height: 350)
                .chartBackground { proxy in
                    VStack(alignment: .center, spacing: 2){
                        Text("\(budget.title)")
                        budget.totalSpent.displayColoredUSD()
                    }
                }
                
            } else {
                VStack {
                    Text("\(budget.title)")
                    budget.totalSpent.displayColoredUSD()
                }
            }
        }
    }
    
    @ViewBuilder
    private var mostUsedTagsBarChart: some View {
        Chart {
            tagSpendingChart
        }
        .chartYAxis {
            AxisMarks(format: Decimal.FormatStyle.Currency.currency(code: "USD"))
        }
    }
    
    @ChartContentBuilder
    private var tagSpendingChart: some ChartContent {
        ForEach(viewModel.allTags) { tag in
            if let amount = tag.totalAmountTracked, amount != 0 {
                BarMark(
                    x: .value("Shape Type", tag.title),
                    y: .value("Total Spent", abs(amount))
                ).foregroundStyle(.red)
            }
        }
    }
}
