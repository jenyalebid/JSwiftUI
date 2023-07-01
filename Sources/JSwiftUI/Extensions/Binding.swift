//
//  Binding.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 6/30/23.
//

import SwiftUI

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = $0 }
    )
}
