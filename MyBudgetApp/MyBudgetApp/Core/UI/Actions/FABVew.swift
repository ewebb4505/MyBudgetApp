//
//  FABVew.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import SwiftUI

struct FABVew: View {
    var image: Image
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            withAnimation {
                action()
            }
        }, label: {
            image
                .font(.body.weight(.bold))
                .frame(width: 50, height: 50)
                .foregroundColor(Color.white)
        })
        .background(Color.blue)
        .cornerRadius(38.5)
        .padding()
        .shadow(color: Color.black.opacity(0.1),
                radius: 3,
                x: 3,
                y: 3)
    }
}

#Preview {
    FABVew(image: Image(systemName: "plus")) {
        print("something")
    }
}
