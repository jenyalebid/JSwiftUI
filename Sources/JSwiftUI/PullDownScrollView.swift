//
//  SwiftUIView.swift
//
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI

public struct PullDownScrollView<Content: View, PullDownContent: View>: View {
    
    @State private var scrollPosition: CGFloat = .zero
    @State private var lastRecordedScroll: CGFloat = .zero
    @State private var pullDownGeometry: CGFloat = .zero
    
    private var scrollID = "pulldownScrolView-\(UUID().uuidString)"
    
    var showsIndicators: Bool
    @State var offset: CGFloat = 0
    
    @ViewBuilder var content: Content
    @ViewBuilder var pullDownContent: (_ position: CGFloat) -> PullDownContent
    
    public init(showsIndicators: Bool = true, @ViewBuilder content: () -> Content, @ViewBuilder pullDownContent: @escaping (_ position: CGFloat) -> PullDownContent) {
        self.showsIndicators = showsIndicators
        self.content = content()
        self.pullDownContent = pullDownContent
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            if scrollPosition > 0 {
                pullDownContent(scrollPosition)
//                    .background(
//                        GeometryReader { geometry in
//                            Color.clear
//                                .onAppear {
//                                    pullDownGeometry = geometry.size.height
//                                }
//                        }
//                    )
//                    .offset(y: -pullDownGeometry + scrollPosition)
            }
            ScrollView(showsIndicators: showsIndicators) {
                content
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geometry.frame(in: .named(scrollID)).origin)
                    })
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        scrollPosition = value.y
                    }
                    .onChange(of: scrollPosition) { oldValue, newValue in
                        print("SCROLL \(newValue)")
                    }
            }
            .coordinateSpace(name: scrollID)
        }
        .clipped()
    }
}

fileprivate struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
    }
}

public struct PullTest: View {
    
    public init() {
        
    }
    
    public var body: some View {
        VStack {
            PullDownScrollView {
                VStack {
                    ForEach((1...1), id: \.self) { row in
                        Text("Row \(row)")
                            .frame(height: 30)
                            .id(row)
                    }
                }
            } pullDownContent: { position in
                Text("\(position)")
            }
        }
    }
}

//#Preview {
//    PullDownScrollView {
//
//    }
//}
