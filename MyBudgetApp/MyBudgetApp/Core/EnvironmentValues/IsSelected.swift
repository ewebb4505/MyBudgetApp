//
//  IsSelected.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 11/15/23.
//

import SwiftUI
import Foundation

private struct IsSelectedKey: EnvironmentKey {
  static let defaultValue = false
}

extension EnvironmentValues {
  var isSelected: Bool {
    get { self[IsSelectedKey.self] }
    set { self[IsSelectedKey.self] = newValue }
  }
}

extension View {
    func isSelected(_ value: Bool) -> some View {
        environment(\.isSelected, value)
    }
}
