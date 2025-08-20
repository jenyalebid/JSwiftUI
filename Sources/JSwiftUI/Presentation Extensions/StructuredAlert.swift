//
//  StructuredAlert.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 8/15/25.
//

import SwiftUI

public struct StructuredAlert: Equatable {
    var title: String
    var message: String
    var actions: [ButtonAction]?
    
    public init(title: String, message: String, actions: [ButtonAction] = [.ok]) {
        self.title = title
        self.message = message
        self.actions = actions
    }
    
    public struct ButtonAction: Identifiable, Equatable {
        public var id = UUID()
        
        public static func == (lhs: StructuredAlert.ButtonAction, rhs: StructuredAlert.ButtonAction) -> Bool {
            lhs.id == rhs.id
        }
        
        var role: ButtonRole?
        var label: String
        var action: () -> Void
        
        public init(role: ButtonRole? = nil, label: String, action: @escaping () -> Void) {
            self.role = role
            self.label = label
            self.action = action
        }
        
        public static let ok: ButtonAction = .init(label: "Okay") { }
    }
    

}

extension View {
    public func alert(_ alert: Binding<StructuredAlert?>) -> some View {
        modifier(StructuredAlertModifier(alert: alert))
    }
}

struct StructuredAlertModifier: ViewModifier {
    
    @State private var isPresented: Bool = false
    
    @Binding var alert: StructuredAlert?
    
    func body(content: Content) -> some View {
        content
            .alert(title, isPresented: $isPresented, actions: {
                actions
            }, message: {
                message
            })
            .onChange(of: alert) { oldValue, newValue in
                isPresented = newValue != nil
            }
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue == false {
                    alert = nil
                }
            }
    }
    
    private var title: String {
        alert?.title ?? ""
    }
    
    private var message: Text {
        Text(alert?.message ?? "")
    }
    
    @ViewBuilder
    var actions: some View {
        if let alert {
            ForEach(alert.actions ?? []) { action in
                Button(action.label, role: action.role) {
                    action.action()
                }
            }
        }
        else {
            Button("Dismiss") {}
        }
    }
}


