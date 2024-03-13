//
//  DebugView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 1/31/24.
//

import SwiftUI

struct DebugView: View {
    var appEnv = AppEnvironmentManager.instance
    
    var body: some View {
        List {
            Section("data") {
                HStack {
                    Text("Clear all input data from server.")
                    Spacer()
                    Button(role: .destructive) {
                        
                    } label: {
                        Text("Clear Data")
                    }
                    .controlSize(.small)
                    .buttonStyle(.borderedProminent)
                }
            }
            
            if appEnv.user != nil {
                Section("Auth Token") {
                    HStack {
                        Text("Auth Token")
                        Spacer()
                        if let token = appEnv.getToken() {
                            Text("\(token.token)")
                                .foregroundStyle(.secondary)
                        } else {
                            Text("NONE")
                                .foregroundStyle(.red)
                        }
                    }
                    
                    HStack {
                        Text("Is Expired?")
                        Spacer()
                        if let token = appEnv.getToken() {
                            if token.hasExpired() {
                                Text("yes")
                                    .foregroundStyle(.red)
                            } else {
                                Text("no")
                                    .foregroundStyle(.green)
                            }
                        } else {
                            Text("NONE")
                                .foregroundStyle(.red)
                        }                    }
                }
            }
            
        }
    }
}

#Preview {
    DebugView()
}
