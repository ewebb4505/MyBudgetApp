//
//  LoginViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation

@MainActor
class LoginCreateAccountViewModel: ObservableObject {
    enum ViewState {
        case login
        case createAccount
    }
    
    enum FocusableField: Hashable {
        case login
        case password
        case passCheck
    }
    
    @Published var loginNameInput: String = ""
    @Published var loginNamePassword: String = ""
    
    @Published var createAccountName: String = ""
    @Published var createAccountPassword: String = ""
    @Published var createAccountPasswordCheck: String = ""

    @Published var viewState: ViewState = .login
    @Published var processingRequest: Bool = false
    
    var isLoginButtonEnabled: Bool {
        !loginNameInput.isEmpty && !loginNamePassword.isEmpty
    }
    
    func onAppearHandle() {
        
    }
    
    func submitLoginInfo() async -> Bool {
        return false
    }
    
    func createAccountButtonTapped() {
        
    }
    
    func submitNewAccountInfo() async -> Bool {
        return false
    }
}
