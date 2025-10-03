//
//  ScrollToTopModifier.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 11/10/24.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect

struct ScrollToTopModifier: ViewModifier {
    
    @Weak private var scrollView: UIScrollView?
    @State private var initialNavBarHeight: CGFloat?
    @Environment(\.navigation) private var navigation

    func body(content: Content) -> some View {
        content
            .introspect(.scrollView, on: .iOS(.v17, .v18, .v26), customize: { scrollView in
                self.scrollView = scrollView
            })
            .onAppear {
                initialNavBarHeight = navigation.controller?.navigationBar.frame.height
            }
            .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
//                let topOffset = CGPoint(x: 0, y: -(scrollView?.adjustedContentInset.top ?? 0))
//                scrollView?.setContentOffset(topOffset, animated: true)
                
                guard (scrollView?.contentOffset.y ?? 0) > 0 else {
                    return
                }
                
                if let viewController = scrollView?.getOwningViewController() {
                    if let navigationController = viewController.navigationController {
                        let navigationBarHeight = navigationController.navigationBar.frame.height
                        let topOffset = CGPoint(x: 0, y: -(scrollView?.adjustedContentInset.top ?? 0) - (navigationBarHeight))
                        scrollView?.setContentOffset(topOffset, animated: true)
                    }
                }
            }
    }
}

public extension View {
    func scrollToTopListener() -> some View {
        modifier(ScrollToTopModifier())
    }
}
