//
//  BudgetsViewModel.swift
//  BudgetApp
//
//  Created by Evan Webb on 10/25/23.
//

import Combine
import Foundation

@MainActor
class BudgetsViewModel: ObservableObject {
    enum InputState: Hashable {
        case title, startingAmount, startDate, endDate
    }
    
    @Published var budgets: [Budget] = []
    @Published var isLoadingResults: Bool = false
    @Published var errorProcessingCreateRequest: Bool = false
    
    // form params
    @Published var titleInput: String = ""
    @Published var startingAmount: String = ""
    @Published var startDate: Date = .now
    @Published var endDate: Date = .now
    
    var service: BudgetSearchable
    
    init(service: BudgetSearchable = BudgetService(requestManager: RequestManager())) {
        self.service = service
    }
    
    func getBudgets() async {
        isLoadingResults = true
        let results = await service.getBudgets()
        self.budgets = results
        isLoadingResults = false
    }
    
    func createBudget() async {
        // TODO: add client side error handling for form
        guard let startingAmountDouble = Double(startingAmount) else {
            return
        }
        
        guard !titleInput.isEmpty else {
            return
        }
        
        guard startDate != endDate else {
            return
        }
        
        guard let result = await service.createBudget(title: titleInput,
                                                      startDate: startDate,
                                                      endDate: endDate,
                                                      amount: startingAmountDouble) else {
            errorProcessingCreateRequest = true
            return
        }
        budgets.append(result)
    }
    
    // the furthest a budget can go is one year
    func acceptableDateRange() -> ClosedRange<Date> {
        let calendar = Calendar.current
        let tomorrow = startDate.addingTimeInterval(3600 * 24)
        let startDateInAYear = calendar.date(byAdding: .year, value: 1, to: tomorrow)!
        return tomorrow ... startDateInAYear
    }
}
