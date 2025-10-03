//
//  _JS.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 10/2/25.
//

import Foundation

public var IS_iOS26: Bool {
    if #available(iOS 26.0, *) {
        return true
    }
    else {
        return false
    }
}

