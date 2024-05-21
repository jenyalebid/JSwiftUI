//
//  ViewSizeConditionalStack.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 5/17/24.
//

import SwiftUI

fileprivate struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

public struct ViewSizeConditionalStack<Primary: View, Secondary: View>: View {
    
    @State private var primarySize: CGSize = .zero
    private var percentageThreshold: CGFloat
    
    private var geometry: GeometryProxy
    private var override: Bool
    
    var primaryView: (_ isVStack: Bool) -> Primary
    var secondaryView: Secondary
    
    
    public init(percentage: CGFloat, geometry: GeometryProxy, override: Bool = false, 
                @ViewBuilder primary: @escaping (_ isVStack: Bool) -> Primary, @ViewBuilder secondary: () -> Secondary) {
        percentageThreshold = percentage
        self.geometry = geometry
        self.override = override
        
        primaryView = primary
        secondaryView = secondary()
    }

    
    public var body: some View {
        let layout = shouldUseVStack(geometry: geometry) ?
        AnyLayout(VStackLayout(alignment: .leading)) : AnyLayout(HStackLayout())
        layout {
            primaryView(shouldUseVStack(geometry: geometry))
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: SizePreferenceKey.self, value: proxy.size)
                    }
                )
                .fixedSize(horizontal: override ? false : true, vertical: true)
                .onPreferenceChange(SizePreferenceKey.self) { size in
                    primarySize = size
                }
            secondaryView
        }
    }
    
//    private func shouldUseVStack(geometry: GeometryProxy) -> Bool {
//        let availableWidth = geometry.size.width
//        let cardWidthPercentage = cardSize.width / availableWidth
//
//        return cardWidthPercentage >= 8 / 15
//    }
    
    private func shouldUseVStack(geometry: GeometryProxy) -> Bool {
        guard !override else { return true }
        
        let availableWidth = geometry.size.width
        let cardWidthPercentage = (primarySize.width / availableWidth) * 100
        
        return cardWidthPercentage > percentageThreshold
    }
}

#Preview {
    GeometryReader(content: { geometry in
        ViewSizeConditionalStack(percentage: 57, geometry: geometry) { isVStack in
            Text("Work on this rwe werwerwer")
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .foregroundColor(.white)
        } secondary: {
            Text("This is an example note that might be long and needs to wrap around the card ert.")
                .font(.caption)
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    })

}
