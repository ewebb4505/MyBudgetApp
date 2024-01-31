//
//  DollarAmountValidator.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/14/23.
//

import Foundation

enum DollarAmountValidator {
    static func isValid(_ value: String) -> Bool {
        let amountSplit = value.components(separatedBy: ".")
        if amountSplit.count > 2 {
            //if there is more than two decimal points, that isn't accurate
            return false
            
        } else if amountSplit.count == 2 {
            //there is one decimal point.
            //check left side of the decimal
            print(amountSplit)
            
            let left = amountSplit[0]
            let right = amountSplit[1]
            
            if right.isEmpty {
                return false
            }
            
            var isAllNumbers = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: left))
            if isAllNumbers {
                //leftside is all numbers but make sure it's not all 0s because that's not accurate
                if hasAllZeros(left) {
                    return false
                }
                else {
                
                    if right.count > 2 { return false }
                    isAllNumbers = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: right))
                    if isAllNumbers {
                        return true
                    } else {
                        return false
                    }
                }
            }
            else {
                return false
            }
            
        } else {
            //there is no decimal so check to make sure there are only numbers.
            let num = amountSplit[0]
            let isAllNumbers = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: num))
            if isAllNumbers {
                //leftside is all numbers but make sure it's not all 0s because that's not accurate
                if hasAllZeros(num) {
                    return false
                } else {
                    return true
                }
            } else {
                return false
            }
        }
    }
    
    private static func hasAllZeros(_ str: String) -> Bool {
        var hasNonZero = true
        str.forEach({ char in
            if char != "0" { hasNonZero = false }
        })
        return hasNonZero
    }
}
