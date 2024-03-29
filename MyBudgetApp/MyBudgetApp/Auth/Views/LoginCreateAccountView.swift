//
//  LoginCreateAccountView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/2/24.
//

import SwiftUI

struct LoginCreateAccountView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: LoginCreateAccountViewModel
    @FocusState private var focus: LoginCreateAccountViewModel.FocusableField?
    
    var body: some View {
        NavigationStack {
            Form {
                if vm.viewState == .login {
                    Section {
                        TextField("Username", text: $vm.loginNameInput)
                            .focused($focus, equals: .login)
                            .onSubmit(of: .text) {
                                focus = .password
                            }
                        SecureField("Password", text: $vm.loginNamePassword)
                            .textContentType(.password)
                            .focused($focus, equals: .password)
                        HStack {
                            Spacer()
                            if vm.processingRequest {
                                ProgressView()
                            } else {
                                Button("Login") {
                                    Task {
                                        if await vm.submitLoginInfo() {
                                            vm.clearInputs()
                                            dismiss()
                                        }
                                    }
                                }
                                .disabled(!vm.isLoginButtonEnabled)
                            }
                        }
                    }
                    
                } else {
                    Section {
                        TextField("Username", text: $vm.createAccountName)
                            .focused($focus, equals: .login)
                            .onSubmit(of: .text) {
                                focus = .password
                            }
                        SecureField("Password", text: $vm.createAccountPassword)
                            .textContentType(.newPassword)
                            .focused($focus, equals: .password)
                            .onSubmit(of: .text) {
                                focus = .passCheck
                            }
                        SecureField("Password Again", text: $vm.createAccountPasswordCheck)
                            .textContentType(.newPassword)
                            .focused($focus, equals: .passCheck)
                            .onSubmit(of: .text) {
                                vm.checkCreateAccountPassword()
                            }
                        HStack {
                            Spacer()
                            Button("Create Account") {
                                Task {
                                    await vm.createAccountButtonTapped()
                                }
                            }
                            .disabled(!vm.isCreateAccountButtonEnabled)
                        }
                    } footer: {
                        if vm.showPasswordsNotMatchingForCreateAccount {
                            Text("Passwords do not match. Try again.")
                                .foregroundStyle(.red)
                        }
                    }
                }
                Section {
                    if vm.viewState == .login {
                        Button {
                            vm.viewState = .createAccount
                        } label: {
                            Text("Create Account")
                        }
                    } else {
                        Button {
                            vm.viewState = .login
                        } label: {
                            Text("Login With Existing Account")
                        }
                    }
                }
                .navigationTitle("Sign In")
            }
            .defaultFocus($focus, .login)
            .toolbar(.visible, for: .automatic)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
            }
        }
    }
}

#Preview {
    LoginCreateAccountView(vm: LoginCreateAccountViewModel())
}
