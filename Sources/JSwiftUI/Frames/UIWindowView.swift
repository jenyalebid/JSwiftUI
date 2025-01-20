////
////  SwiftUIView.swift
////  JSwiftUI
////
////  Created by Jenya Lebid on 1/18/25.
////
//
//import SwiftUI
//import UIKit
//
///// A custom container UIViewController that holds a UIHostingController.
///// This container can define its own presentation context so that
///// modals (sheets, fullScreens) are confined to this controller’s view bounds.
//class ConstrainedHostingController<Content: View>: UIViewController {
//    
//    private let hostingController: UIHostingController<Content>
//    
//    /// The size we want this "sub-window" to be.
//    private var targetSize: CGSize
//    
//    init(rootView: Content, size: CGSize) {
//        self.targetSize = size
//
//        // Create the hosting controller with the SwiftUI content.
//        self.hostingController = UIHostingController(rootView: rootView)
//        let window = UIWindow(frame: CGRect(origin: CGPoint(x: 300, y: 300), size: size))
//        window.makeKeyAndVisible()
//        window.rootViewController = hostingController
//        
//        super.init(nibName: nil, bundle: nil)
//        
//        
//        // We want any modal presentation to remain *inside* this container.
////        self.definesPresentationContext = true
//        
//        // Force modals to present in the current context rather than the topmost window.
////        self.hostingController.modalPresentationStyle = .currentContext
//        
//        // Embed the hostingController as a child.
//        addChild(hostingController)
//        view.addSubview(hostingController.view)
//        hostingController.didMove(toParent: self)
//        
//        // (Optional) If you want to override trait collections to look like an iPhone, you could do:
//        // hostingController.overrideUserInterfaceStyle = .light // or dark
//        // or override this VC’s traitCollection, described below.
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    /// SwiftUI will call this whenever the parent view’s layout changes.
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        // Make the hosted content fill our container’s bounds.
//        hostingController.view.frame = CGRect(origin: .zero, size: view.bounds.size)
//    }
//    
//    func updateSize(_ size: CGSize) {
//        self.targetSize = size
//        // We can set `preferredContentSize` if we’re in a popover or something,
//        // but mostly we rely on SwiftUI’s .frame(...) to size this container.
//        self.preferredContentSize = size
//        // Trigger a layout pass if needed:
//        self.view.setNeedsLayout()
//    }
//    
//    func updateContent(_ content: Content) {
//        hostingController.rootView = content
//    }
//    
//    // —————————————————————————————————————
//    // (Optional) Trick iOS into thinking we’re on a smaller device.
//    // For example, to mimic an iPhone with compact width/regular height:
//    // —————————————————————————————————————
//    /*
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        self.setOverrideTraitCollection(
//            UITraitCollection(traitsFrom: [
//                UITraitCollection(horizontalSizeClass: .compact),
//                UITraitCollection(verticalSizeClass: .regular)
//            ]),
//            forChild: hostingController
//        )
//    }
//    */
//}
//
///// `ConstrainedWindowView` is a SwiftUI View that
///// hosts content in a "sub-window" style container.
///// Any .sheet or .fullScreenCover from that content
///// will stay confined to this container’s area.
//
//struct ConstrainedWindowView<Content: View>: UIViewControllerRepresentable {
//    @Binding var size: CGSize
//    @ViewBuilder var content: Content
//    
//    func makeUIViewController(context: Context) -> ConstrainedHostingController<Content> {
//        ConstrainedHostingController(rootView: content, size: size)
//    }
//    
//    func updateUIViewController(_ uiViewController: ConstrainedHostingController<Content>,
//                                context: Context) {
//        // Update the SwiftUI content
//        uiViewController.updateContent(content)
//        
//        // Update the size
//        uiViewController.updateSize(size)
//    }
//}
//
//struct DemoSubWindowView: View {
//    @State private var windowSize = CGSize(width: 333, height: 600)
//    
//    var body: some View {
//        GeometryReader { geometry in
//            Text("Host a 'Sub-Window' Below")
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .overlay(alignment: .center) {
//                    ConstrainedWindowView(size: $windowSize) {
//                        DemoInnerTest()
//                    }
//                    .frame(width: windowSize.width, height: windowSize.height)
//                }
//        }
//    }
//}
//
//struct DemoInnerTest: View {
//    
//    var body: some View {
//        Rectangle()
//            .foregroundColor(.red.opacity(0.3))
//            .sheet(isPresented: .constant(true)) {
//                Text("HI!!!!!!")
//            }
//    }
//}
//
//
////class CustomSheetPresenter: UIPrese {
////    
////    
////}
//
//#Preview {
//    ContentViewS()
//}
//
//
//
//class WindowManager {
//    static let shared = WindowManager()
//    private var window: UIWindow?
//
//    func createWindow(size: CGSize, content: UIViewController) {
//        guard window == nil else { return } // Ensure only one window exists
//        let newWindow = UIWindow(frame: CGRect(origin: .zero, size: size))
//        newWindow.rootViewController = content
//        newWindow.windowScene = UIApplication.shared.connectedScenes
//            .compactMap { $0 as? UIWindowScene }
//            .first
//        newWindow.makeKeyAndVisible()
//        window = newWindow
//    }
//
//    func updateContent(_ content: UIViewController) {
////        window?.rootViewController = content
//    }
//
//    func dismissWindow() {
//        window?.isHidden = true
//        window = nil
//    }
//}
//
//struct WindowView<Content: View>: UIViewControllerRepresentable {
//    var size: CGSize
//    @ViewBuilder var content: Content
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let hostingController = UIHostingController(rootView: content)
//        WindowManager.shared.createWindow(size: size, content: hostingController)
//        return hostingController
//    }
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
//        if let hostingController = uiViewController as? UIHostingController<Content> {
//            hostingController.rootView = content
//            WindowManager.shared.updateContent(hostingController)
//        }
//    }
//
//    static func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
//        WindowManager.shared.dismissWindow()
//    }
//}
//
//struct ContentViewS: View {
//    @State private var showWindow = false
//    @State private var windowSize = CGSize(width: 400, height: 300)
//
//    var body: some View {
//        VStack {
//            Button("Show UIWindow") {
//                showWindow = true
//            }
//            Button("Hide UIWindow") {
//                WindowManager.shared.dismissWindow()
//            }
//        }
//        .sheet(isPresented: $showWindow) {
//            WindowView(size: windowSize) {
//                VStack {
//                    Text("This is a UIWindow!")
//                        .font(.headline)
//                    Button("Close") {
//                        showWindow = false
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//}
