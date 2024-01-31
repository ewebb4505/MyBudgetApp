//
//  DollarAmountTextField.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import SwiftUI

struct DollarAmountTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(spacing: 0) {
            
            Text("$")
                .font(.system(size: 64))
            Spacer()
            configuration
                .font(.system(size: 64))
        
        }
        .border(.green)
    }
}

//#Preview {
//    TextField("0.00", text: .constant(""))
//        .textFieldStyle(DollarAmountTextFieldStyle(input: .constant("")))
//}
