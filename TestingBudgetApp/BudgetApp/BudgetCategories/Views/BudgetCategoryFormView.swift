//
//  BudgetCategoryFormView.swift
//  BudgetApp
//
//  Created by Evan Webb on 11/7/23.
//

import Combine
import SwiftUI

struct BudgetCategoryFormView: View {
    @ObservedObject var vm: CreateBudgetCategoryViewModel
    var budget: Budget
    
    var body: some View {
        Form {
            TextField("Category Name", text: $vm.titleInput)
            
            TextField("Category Max Amount", text: $vm.maxAmount)
                .keyboardType(.numbersAndPunctuation)
                .onReceive(Just(vm.maxAmount)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.vm.maxAmount = filtered
                    }
                }
            
            Section {
                Button {
                    Task { await vm.createBudgetCategory(for: budget) }
                } label: {
                    Text("Create Budget Category")
                }
                .buttonStyle(.borderless)
            }
        }
        .onDisappear {
            vm.titleInput = ""
            vm.maxAmount = ""
        }
    }
}
