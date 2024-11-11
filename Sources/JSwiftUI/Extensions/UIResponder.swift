//
//  UIResponder.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/10/24.
//

import UIKit

public extension UIResponder {
    
    func getOwningViewController() -> UIViewController? {
        var nextResponder = self.next
        while let responder = nextResponder {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            nextResponder = responder.next
        }
        return nil
    }
}
