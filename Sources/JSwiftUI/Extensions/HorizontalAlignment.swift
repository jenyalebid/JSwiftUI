//
//  HorizontalAlignment.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/11/26.
//

import SwiftUI

public extension HorizontalAlignment {
    
    func alignment() -> Alignment {
        switch self {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }
}
