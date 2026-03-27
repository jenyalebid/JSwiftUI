//
//  KeyboardDoneModifier.swift
//  JSwiftUI
//

import SwiftUI
import SwiftUIIntrospect

public struct KeyboardDoneModifier: ViewModifier {

    var title: String
    var show: Bool

    public init(title: String = "Done", show: Bool = true) {
        self.title = title
        self.show = show
    }

    public func body(content: Content) -> some View {
        if show {
            content
                .introspect(.textField, on: .iOS(.v17, .v18, .v26)) { textField in
                    textField.addDismissButton(title: title)
                }
                .introspect(.textEditor, on: .iOS(.v17, .v18, .v26)) { textEditor in
                    textEditor.addDismissButton(title: title)
                }
        }
        else {
            content
        }
    }

    public struct ToolbarButton: ToolbarContent {

        public init() {}

        public var body: some ToolbarContent {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    } label: {
                        Text("Done")
                            .font(.headline)
                    }
                }
            }
        }
    }
}

public extension UITextField {

    func addDismissButton(title: String) {
        if let _ = inputAccessoryView as? UIToolbar {
            return
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(
            title: title,
            style: .done,
            target: self,
            action: #selector(resignFirstResponder)
        )

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let trailingSpace = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        trailingSpace.width = 8

        toolbar.items = [flexibleSpace, doneButton, trailingSpace]
        inputAccessoryView = toolbar
    }
}

public extension UITextView {
    func addDismissButton(title: String) {
        if let _ = inputAccessoryView as? UIToolbar { return }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: title, style: .done, target: self, action: #selector(resignFirstResponder))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let trailingSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        trailingSpace.width = 8
        toolbar.items = [flexibleSpace, doneButton, trailingSpace]
        self.inputAccessoryView = toolbar
    }
}

public extension View {
    func keyboardDoneToolbar(title: String = "Done", show: Bool = true) -> some View {
        modifier(KeyboardDoneModifier(title: title, show: show))
    }
}
