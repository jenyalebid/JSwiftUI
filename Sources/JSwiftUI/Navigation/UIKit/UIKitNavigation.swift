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
    
    public private(set) var viewController = UINavigationController()
    
    public var id: String
    
    public init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    public func setupController(from viewController: UINavigationController) {
        self.viewController = viewController
    }
}

public extension UIKitNavigation {
    
    func push<V: View>(_ view: V, animated: Bool = true) {
        let host = UIHostingController(rootView: view)
        host.navigationItem.largeTitleDisplayMode = .never
        host.navigationItem.style = .browser
        host.toolbarItems = nil
        
        viewController.pushViewController(host, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        viewController.popViewController(animated: animated)
    }
    
    func goBack(animated: Bool = true) {
        viewController.topViewController?.dismiss(animated: animated)
    }
}

fileprivate struct UIKitNavigationModifier<I: Hashable, V: View>: ViewModifier {
    
    @Binding var item: I?
    @ViewBuilder var destination: (_: I) -> V
    @Environment(\.uiKitNavigation) private var navigation
    
    func body(content: Content) -> some View {
        content
            .onChange(of: item) { oldValue, newValue in
                if let newValue {
                    navigation.push(destination(newValue))
                }
            }
    }
}

public extension View {
    
    func uiKitNavigationDestination<I: Hashable, V: View>(item: Binding<I?>,
                                                          @ViewBuilder destination: @escaping (_ item: I) -> V) -> some View {
        modifier(UIKitNavigationModifier(item: item, destination: destination))
    }
}
