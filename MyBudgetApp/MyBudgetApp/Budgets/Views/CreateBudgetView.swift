//
//  CreateBudgetView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/25/24.
//

import Combine
import SwiftUI

struct CreateBudgetView: View {
    @Binding var titleInput: String
    @Binding var startingAmount: String
    @Binding var startDate: Date
    @Binding var endDate: Date
    
    @FocusState private var textfieldFocused: Bool
    
    var action: () async -> Void
    
    var acceptableDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let tomorrow = startDate.addingTimeInterval(3600 * 24)
        let startDateInAYear = calendar.date(byAdding: .year, value: 1, to: tomorrow)!
        return tomorrow ... startDateInAYear
    }
    
    var body: some View {
        Form {
            TextField("Title", text: $titleInput)
                //.focused($focus, equals: BudgetsViewModel.InputState.title)
            
            TextField("Starting Amount", text: $startingAmount)
                .focused($textfieldFocused)
                .keyboardType(.numbersAndPunctuation)
                .onLongPressGesture(minimumDuration: 0.0) {
                    textfieldFocused = true
                }
                .autocorrectionDisabled()
//                .onReceive(Just(startingAmount)) { newValue in
//                    let filtered = newValue.filter { "0123456789".contains($0) }
//                    if filtered != newValue {
//                        startingAmount = filtered
//                    }
//                }
            
            DatePicker("Start Date of Budget",
                       selection: $startDate,
                       displayedComponents: .date)
                //.focused($focus, equals: BudgetsViewModel.InputState.startDate)
                .datePickerStyle(.automatic)
            
            DatePicker("End Date of Budget",
                       selection: $endDate,
                       in: acceptableDateRange,
                       displayedComponents: .date)
                //.focused($focus, equals: BudgetsViewModel.InputState.endDate)
                .datePickerStyle(.automatic)
            
            Section {
                Button {
                    Task { await action() }
                } label: {
                    Text("Create Budget")
                }
                .buttonStyle(.borderless)
            }
        }
    }
}
