//
//  BudgetsMainTabViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 3/24/24.
//

import Foundation

@Observable
class BudgetsMainTabViewModel {
    var budgets: [Budget] = []
    var currentBudgets: [Budget] = []
    
    var createBudgetName: String = ""
    var createBudgetStartDate: Date = .now
    var createBudgetEndDate: Date = .now
    var createBudgetStartingAmount: String = ""
    
    var createBudgetCategoryName: String = ""
    var createBudgetCategoryMaxAmount: String = ""
    
    var showCreateBudgetSheet: Bool = false
    var errorCreatingBudget: Bool = false
    
    private var budgetNetworkService: BudgetNetworkServiceProtocol = BudgetNetworkService(requestManager: RequestManager())
    private var budgetCategoryNetworkService: BudgetCategoryNetworkServiceProtocol = BudgetCategoryService(requestManager: RequestManager())
    
    func fetchBudgets() async {
        currentBudgets = await budgetNetworkService.getBudgets(isActive: true)
    }
    
    func createBudget() async -> Bool {
        guard let startingAmountDouble = Double(createBudgetStartingAmount) else {
            return false
        }
        
        guard !createBudgetName.isEmpty else {
            return false
        }
        
        guard createBudgetStartDate != createBudgetEndDate else {
            return false
        }
        
        guard let result = await budgetNetworkService.createBudget(title: createBudgetName,
                                                      startDate: createBudgetStartDate,
                                                      endDate: createBudgetEndDate,
                                                      amount: startingAmountDouble) else {
            errorCreatingBudget = true
            return false
        }
        currentBudgets.append(result)
        return true
    }
    
    func deleteBudget(budgetID: Budget.ID) async -> Bool {
        if await budgetNetworkService.deleteBudget(id: budgetID) {
            currentBudgets.removeAll(where: { $0.id == budgetID })
            return true
        } else {
            return false
        }
    }
}
