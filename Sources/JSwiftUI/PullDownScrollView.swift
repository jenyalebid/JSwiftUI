//
//  SwiftUIView.swift
//
//
//  Created by Jenya Lebid on 4/20/24.
//

import SwiftUI
import SwiftUIIntrospect

public struct PullDownScrollView<Content: View, PullDownContent: View>: View {
    
    @State private var scrollPosition: CGFloat = .zero
    @State private var lastRecordedScroll: CGFloat = .zero
    @State private var pullDownGeometry: CGFloat = .zero
    
    @State private var isDragging = false
    
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
//        .clipped()
    }
    
    private func makeCoordinator(scrollView: UIScrollView) -> Coordinator {
          Coordinator(isDragging: $isDragging, scrollView: scrollView)
    }
}

struct DraggableScrollView: UIViewRepresentable {
    @Binding var isDragging: Bool

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.delegate = context.coordinator
        setupScrollView(scrollView: scrollView)
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        // Update logic if needed
    }

    // Coordinator to act as UIScrollViewDelegate
    func makeCoordinator() -> Coordinator {
        Coordinator(isDragging: $isDragging)
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        @Binding var isDragging: Bool

        init(isDragging: Binding<Bool>) {
            _isDragging = isDragging
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            isDragging = true
        }

        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                isDragging = false
            }
        }

        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            isDragging = false
        }
    }

    private func setupScrollView(scrollView: UIScrollView) {
        // Setup content for scrollView in a UIKit way
        let contentView = UIView()
        contentView.backgroundColor = .lightGray
        let contentSize = 1000
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: CGFloat(contentSize))

        for i in 0..<50 {
            let label = UILabel(frame: CGRect(x: 20, y: i * 20, width: Int(scrollView.frame.size.width) - 40, height: 18))
            label.text = "Item \(i)"
            label.textColor = .black
            contentView.addSubview(label)
        }

        scrollView.addSubview(contentView)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: CGFloat(contentSize))
    }
}

fileprivate class Coordinator: NSObject, UIScrollViewDelegate {
    
    @Binding var isDragging: Bool
    weak var scrollView: UIScrollView?

    init(isDragging: Binding<Bool>, scrollView: UIScrollView) {
        _isDragging = isDragging
        self.scrollView = scrollView
        super.init()
        scrollView.delegate = self  // Ensure the delegate is set to self
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isDragging = false
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isDragging = false
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
