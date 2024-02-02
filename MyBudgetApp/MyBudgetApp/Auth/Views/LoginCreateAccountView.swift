//
//  LoginCreateAccountView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import SwiftUI

struct LoginCreateAccountView: View {
    @StateObject var vm = LoginCreateAccountViewModel()
    @FocusState private var focus: LoginCreateAccountViewModel.FocusableField?
    
    var body: some View {
        NavigationStack {
            Form {
                if vm.viewState == .login {
                    Section {
                        TextField("Username", text: $vm.loginNameInput)
                            .textFieldStyle(.automatic)
                            .focused($focus, equals: .login)
                            .onSubmit(of: .text) {
                                focus = .password
                            }
                        SecureField("Password", text: $vm.loginNamePassword)
                            .textFieldStyle(.automatic)
                            .focused($focus, equals: .password)
                        HStack {
                            Spacer()
                            Button("Login") {
                                Task {
                                    await vm.submitLoginInfo()
                                }
                            }
                            .disabled(!vm.isLoginButtonEnabled)
                        }
                    }
                    
                } else {
                    Section {
                        TextField("Username", text: $vm.createAccountName)
                        SecureField("Password", text: $vm.createAccountPassword)
                        SecureField("Password Again", text: $vm.createAccountPassword)
                    }
                }
                Section {
                    Button {
                        //nothing
                    } label: {
                        Text("Create Account")
                    }
                }
                .navigationTitle("Sign In")
            }
            .defaultFocus($focus, .login)
        }
    }
}

#Preview {
    LoginCreateAccountView()
}
