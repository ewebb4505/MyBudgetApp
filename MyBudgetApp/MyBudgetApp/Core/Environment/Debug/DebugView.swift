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
        }
    }
}

#Preview {
    DebugView()
}
