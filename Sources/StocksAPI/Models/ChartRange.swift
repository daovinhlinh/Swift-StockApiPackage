//
//  File.swift
//
//
//  Created by Đào Vĩnh Linh on 06/06/2024.
//

import Foundation

public enum ChartRange: String, CaseIterable {
    case oneDay = "1d"
    case fiveDay = "5d"
    case oneMonth = "1m"
    case threeMonth = "3m"
    case threeYear = "3y"
    case fiveYear = "5y"

    public var resolution: String {
        switch self {
        case .oneDay, .fiveDay, .oneMonth: return "1"
        case .threeMonth: return "1D"
        case .threeYear, .fiveYear: return "D"
        }
    }
}
