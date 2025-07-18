//
//  Font.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 7/16/25.
//

import SwiftUI

public extension Font.TextStyle {
    
    func decrease(by amount: Int, for threshold: DynamicTypeSize, currentSize: DynamicTypeSize) -> Self {
        currentSize >= threshold ? decrease(by: amount) : self
    }

    func decrease(by amount: Int) -> Self {
        let orderedStyles = Font.TextStyle.allCases
        guard let idx = orderedStyles.firstIndex(of: self) else { return self }
        let newIdx = min(idx + amount, orderedStyles.count - 1)
        return orderedStyles[newIdx]
    }

    func increase() -> Self {
        let orderedStyles = Font.TextStyle.allCases
        guard let idx = orderedStyles.firstIndex(of: self) else { return self }
        let newIdx = max(idx - 1, 0)
        return orderedStyles[newIdx]
    }
}

public extension View {
    /// Overload allowing you to pass a `Font.TextStyle` directly to `.font(_:)`
    func font(_ textStyle: Font.TextStyle) -> some View {
        self.font(.system(textStyle))
    }
}
