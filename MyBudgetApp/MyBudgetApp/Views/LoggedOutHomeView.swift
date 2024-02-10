//
//  LoggedOutHomeView.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 2/10/24.
//

import SwiftUI

struct LoggedOutHomeView: View {
    @Binding var showLoginScreenCover: Bool
    var body: some View {
        ZStack {
            Color.gray.opacity(0.15).ignoresSafeArea()
            
            VStack {
                Text("Log your daily spending and create a budget to meet your money goals!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                Button("Login or Create Account") {
                    showLoginScreenCover = true
                }
                .controlSize(.extraLarge)
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
    }
}

#Preview {
    LoggedOutHomeView(showLoginScreenCover: .constant(false))
}
