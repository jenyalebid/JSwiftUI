//
//  EnvironmentValues+Bool.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/22/26.
//

import SwiftUI

public extension EnvironmentValues {
    /// View is presented over root as either a `sheet`, `fullScreenCover`, or `popover`.
    @Entry var isPresentedOverRoot: Bool = false
}
