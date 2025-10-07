//
//  NavControllerStack.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/10/24.
//

import SwiftUI
import SwiftUIIntrospect

public extension Notification.Name {
    static var tabBarItemToggle = Notification.Name("tab_bar_item_toggle")
    static var scrollToTop = Notification.Name("scroll_to_top")
    static var activateSearch = Notification.Name("activate_search")

}

public struct NavControllerStack<Root: View>: View {
    
    @State private var navigation: UIKitNavigation
    @ViewBuilder var root: Root
    
    public init(id: String = UUID().uuidString, _ root: Root) {
        self._navigation = State(initialValue: UIKitNavigation(id: id))
        self.root = root
    }
    
    public init(id: String = UUID().uuidString, @ViewBuilder _ root: () -> Root) {
        self._navigation = State(initialValue: UIKitNavigation(id: id))
        self.root = root()
    }
    
    public var controller: UIViewController {
        navigation.viewController
    }

    
    public var body: some View {
        NavRepresentable(navigation: navigation) {
            root
        }
        .ignoresSafeArea()
        .onReceive(NotificationCenter.default.publisher(for: .tabBarItemToggle)) { info in
            guard let viewController = info.object as? UIViewController, let isSameController = info.userInfo?.first?.value as? Bool else {
                return
            }
            guard isSameController else { return }

            if let navController = viewController.children.first(where: {$0 is UINavigationController }),
                navController == navigation.viewController {
                navigation.viewController.setNavigationBarHidden(false, animated: true)
                navigation.viewController.hidesBarsOnSwipe = false
                
                if navigation.viewController.viewControllers.count > 1 {
                    navigation.viewController.popToRootViewController(animated: true)
                }
                else {
                    NotificationCenter.default.post(name: .scrollToTop, object: navigation.viewController)
                }
            }
        }
        .environment(\.uiKitNavigation, navigation)
    }
}

fileprivate struct NavRepresentable<Root: View>: UIViewControllerRepresentable {
    
    var navigation: UIKitNavigation
    @ViewBuilder var root: Root
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let host = UIHostingController(rootView: root)
        let nav = UINavigationController(rootViewController: host)
        nav.delegate = context.coordinator
        nav.navigationBar.prefersLargeTitles = true
        
        navigation.setupController(from: nav)
        
        return nav
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
        
        func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
            navigationController.hidesBarsOnSwipe = false
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            true
        }
    }
}
