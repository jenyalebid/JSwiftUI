//
//  UIKitNavigation.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/7/24.
//

import SwiftUI

public struct UIKitNavigationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: UIKitNavigation = UIKitNavigation()
}

public extension EnvironmentValues {
    var uiKitNavigation: UIKitNavigation {
        get { self[UIKitNavigationEnvironmentKey.self] }
        set { self[UIKitNavigationEnvironmentKey.self] = newValue }
    }
}

@Observable
public class UIKitNavigation {
    
    public var id = UUID().uuidString
    
    /// ViewController which is assigned from UIKit.
    public var viewController: UINavigationController?
    
    public var isSetup: Bool {
        viewController != nil
    }
    
    public init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    public func setup(_ viewController: UINavigationController) {
        self.viewController = viewController
    }
    
    func push<V: View>(_ view: V, animated: Bool = true) {
        let host = UIHostingController(rootView: view)
        viewController?.pushViewController(host, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        viewController?.popViewController(animated: animated)
    }
    
    func goBack(animated: Bool = true) {
        viewController?.topViewController?.dismiss(animated: animated)
    }
}
