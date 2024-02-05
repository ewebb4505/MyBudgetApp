//
//  LoginViewModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import Foundation
import SwiftUI

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
    @Published var showPasswordsNotMatchingForCreateAccount = false
    
    var networkService: AuthNetworkServiceProtocol
    var appEnv = AppEnvironmentManager.instance

    
    init(networkService: AuthNetworkServiceProtocol = AuthNetworkService(requestManager: RequestManager())) {
        self.networkService = networkService
    }
    
    var isLoginButtonEnabled: Bool {
        !loginNameInput.isEmpty && !loginNamePassword.isEmpty
    }
    
    var isCreateAccountButtonEnabled: Bool {
        !createAccountName.isEmpty && 
        !createAccountPassword.isEmpty &&
        !createAccountPasswordCheck.isEmpty &&
        createAccountPassword == createAccountPasswordCheck
    }
    
    func onAppearHandle() {
        
    }
    
    func submitLoginInfo() async -> Bool {
        processingRequest = true
        guard let response = await networkService.loginUser(username: loginNameInput,
                                                            password: loginNamePassword) else {
            processingRequest = false
            return false
        }
        
        // set user in env here
        processingRequest = false
        appEnv.setUser(response.user)
        return true
    }
    
    func createAccountButtonTapped() async -> Bool {
        guard createAccountPassword == createAccountPasswordCheck else {
            return false
        }
        processingRequest = true
        guard let response = await networkService.createUser(username: createAccountName,
                                                             password: createAccountPassword) else {
            processingRequest = false
            return false
        }
        
        // set user in env here
        processingRequest = false
        appEnv.setUser(response.user)
        return true
    }
    
    func submitNewAccountInfo() async -> Bool {
        return false
    }
    
    func checkCreateAccountPassword() {
        showPasswordsNotMatchingForCreateAccount = createAccountPassword != createAccountPasswordCheck
    }
}
