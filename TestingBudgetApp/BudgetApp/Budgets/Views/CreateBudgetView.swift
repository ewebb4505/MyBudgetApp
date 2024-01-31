//
//  CreateBudgetView.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/27/23.
//

import Combine
import SwiftUI

struct CreateBudgetView: View {
    @StateObject var vm = BudgetsViewModel()
    @FocusState var focus: BudgetsViewModel.InputState?
    
    var body: some View {
        Form {
            TextField("Title", text: $vm.titleInput)
                .focused($focus, equals: BudgetsViewModel.InputState.title)
            
            TextField("Starting Amount", text: $vm.startingAmount)
                .focused($focus, equals: BudgetsViewModel.InputState.startingAmount)
                .keyboardType(.numbersAndPunctuation)
                .onReceive(Just(vm.startingAmount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.vm.startingAmount = filtered
                    }
                }
            
            DatePicker("Start Date of Budget", 
                       selection: $vm.startDate,
                       displayedComponents: .date)
                .focused($focus, equals: BudgetsViewModel.InputState.startDate)
                .datePickerStyle(.automatic)
            
            DatePicker("End Date of Budget",
                       selection: $vm.endDate,
                       in: vm.acceptableDateRange(),
                       displayedComponents: .date)
                .focused($focus, equals: BudgetsViewModel.InputState.endDate)
                .datePickerStyle(.automatic)
            
            Section {
                Button {
                    Task { await vm.createBudget() }
                } label: {
                    Text("Create Budget")
                }
                .buttonStyle(.borderless)
            }
            
            Section {
                ForEach(vm.budgets) { budget in
                    VStack {
                        Text(budget.title)
                        Text(budget.id.uuidString)
                    }
                }
            } header: {
                Text("Budgets")
            }
        }
        .onSubmit {
            if focus == .title {
                focus = .startingAmount
            } else if focus == .startingAmount {
                focus = .startDate
            } else if focus == .startDate {
                focus = .endDate
            }
        }
        .onAppear {
            Task { await vm.getBudgets() }
        }
    }
}
