//
//  CreateBudgetCategoryViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/31/23.
//

import Foundation

@MainActor
class CreateBudgetCategoryViewModel: ObservableObject {
    enum InputState: Hashable {
        case title, startingAmount, startDate, endDate
    }
    @Published var budgets: [Budget] = []
    @Published var isLoadingResults: Bool = false
    
    // form params
    @Published var titleInput: String = ""
    @Published var maxAmount: String = ""
    
    var service: BudgetCategorySearchable
    var budgetService: BudgetSearchable
    
    init(service: BudgetCategorySearchable = BudgetCategoryService(requestManager: RequestManager()),
         budgetService: BudgetSearchable = BudgetService(requestManager: RequestManager())) {
        self.service = service
        self.budgetService = budgetService
    }
    
    func getBudgets() async {
        budgets = await budgetService.getBudgets()
    }
    
    func createBudgetCategory(for budget: Budget) async {
        guard !titleInput.isEmpty else {
            return
        }
        
        guard let maxAmount = Double(maxAmount) else {
            return
        }
        
        guard let result = await service.createBudgetCategory(for: budget,
                                                              title: titleInput,
                                                              maxAmount: maxAmount) else {
            return
        }
    }
}
