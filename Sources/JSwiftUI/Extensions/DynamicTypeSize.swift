//
//  DynamicTypeSize.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 7/16/25.
//

import SwiftUI

public extension DynamicTypeSize {
    
    var isOversized: Bool {
        self >= .xLarge
    }
}

public extension View {
    
    func maxDynamicTypeSize(_ size: DynamicTypeSize, current: DynamicTypeSize) -> some View {
        self
            .dynamicTypeSize(current > size ? size : current)
    }
}
