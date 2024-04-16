//
//  TagColorModel.swift
//  MyBudgetApp
//
//  Created by Evan Webb on 4/15/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class TagColorModel {
    var color: AvailableColors
    @Attribute(.unique) var tagID: UUID
    
    init(color: AvailableColors, tagID: UUID) {
        self.color = color
        self.tagID = tagID
    }
}

enum AvailableColors: Codable, CaseIterable {
    case red
    case blue
    case green
    case purple
    case orange
    case cyan
    case brown
    case darkGray
    case magenta
}

extension AvailableColors {
    static func getRandomColor() -> AvailableColors {
        AvailableColors.allCases.randomElement()!
    }
    
    var uiColorMapping: UIColor {
        switch self {
        case .red:
                .systemRed
        case .blue:
                .systemBlue
        case .green:
                .systemGreen
        case .purple:
                .systemPurple
        case .orange:
                .systemOrange
        case .cyan:
                .systemCyan
        case .brown:
                .systemBrown
        case .darkGray:
                .darkGray
        case .magenta:
                .magenta
        }
    }
}
