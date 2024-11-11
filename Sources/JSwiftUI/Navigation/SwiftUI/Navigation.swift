//
//  File.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/10/24.
//

import SwiftUI

public struct NavigationEnvironmentKey: EnvironmentKey {
    public static let defaultValue: Navigation = Navigation()
}

public extension EnvironmentValues {
    var navigation: Navigation {
        get { self[NavigationEnvironmentKey.self] }
        set { self[NavigationEnvironmentKey.self] = newValue }
    }
}

class NavGestureDelegate: NSObject, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

class NavDelegate: NSObject, UINavigationControllerDelegate {
    

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.hidesBarsOnSwipe = false
    }
}

@Observable
public class Navigation {
    
    private var gestureDelegate = NavGestureDelegate()
//    private var delegate = NavDelegate()
    
    public var path = NavigationPath()
    public private(set) var viewController = UINavigationController()
    
    public var id: String
    
    public init(id: String = UUID().uuidString) {
        self.id = id
    }
    
    public func setupController(from viewController: UINavigationController) {
        self.viewController = viewController
    }
}
