//
//  SwiftUIView.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/16/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

public extension EnvironmentValues {
    @Entry var navigation = Navigation(id: Navigation.defaultID)
}


@Observable
public class Navigation {
    
    static let defaultID = "_default_"
    
    /// Indicates if this object is provided by default from EnvironmentValues.
    public var isDefault: Bool { id == Navigation.defaultID }
    
    public var id: String
    public var path = NavigationPath()
    
    public unowned var controller: UINavigationController?    
    
    public init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    public init(id: String, controller: UINavigationController?) {
        self.id = id
        self.controller = controller
    }
    
    public func setupController(_ controller: UINavigationController) {
        self.controller = controller
    }
}

public extension Navigation { //MARK: UIKit
    
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool = true) {
        controller?.setNavigationBarHidden(hidden, animated: animated)
    }
    
    func hidesBarsOnSwipe(_ hide: Bool) {
        controller?.hidesBarsOnSwipe = hide
    }
    
    func clearStack() {
        controller?.popToRootViewController(animated: true)
        path = NavigationPath()
    }
}

/// Host for SwiftUI `NavigationStack` to capture  the UIKit `UIViewController`.
/// - Can be accessed with from interioir views with `\.navigation` enviornment.
public struct NavStack<Root: View>: View {
    
    @State private var navigation: Navigation
    @ViewBuilder var root: () -> Root
    
    public init(id: String = UUID().uuidString, @ViewBuilder root: @escaping () -> Root) {
        self._navigation = State(wrappedValue: Navigation(id: id))
        self.root = root
    }
    
    public var body: some View {
        NavigationStack(path: $navigation.path) {
            root()
        }
        .introspect(.navigationStack, on: .iOS(.v17, .v18, .v26), customize: { controller in
            navigation.setupController(controller)
        })
        .environment(\.navigation, navigation)
    }
}
