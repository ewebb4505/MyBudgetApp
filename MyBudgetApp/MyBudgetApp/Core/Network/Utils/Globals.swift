//
//  Globals.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 4/10/24.
//

import Foundation

func verboseNetworkCall<T>(returnFromCatch: T,
                           perform: @autoclosure @escaping () async throws -> T) async -> T {
    do {
        let type: T = try await perform()
        return type
    } catch let DecodingError.dataCorrupted(context) {
        print(context)
        return returnFromCatch
    } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
        return returnFromCatch
    } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
        return returnFromCatch
    } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
        return returnFromCatch
    } catch {
        print("error: ", error)
        return returnFromCatch
    }
}
