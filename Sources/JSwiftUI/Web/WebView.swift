//
//  WebView.swift
//  JSwiftUI
//
//  Created by Jenya Lebid on 1/18/25.
//

import SwiftUI
import WebKit

public struct WebView<Content: View>: View {
    
    @Binding var url: URL
    @State private var isLoading = false
    
    @ViewBuilder var content: (Bool) -> Content
    
    public init(url: Binding<URL>, @ViewBuilder content: @escaping (_ isLoading: Bool) -> Content) {
        self._url = url
        self.content = content
    }
    
    public var body: some View {
        ZStack {
            WebViewRepresentable(url: $url, isLoading: $isLoading)
            if isLoading {
                Rectangle()
                    .fill(.windowBackground)
                ProgressView()
                    .scaleEffect(1.5)
            }
            content(isLoading)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

fileprivate struct WebViewRepresentable: UIViewRepresentable {
    
    @Binding var isLoading: Bool
    @Binding var url: URL
    
    private var initialURL: URL
    
    init(url: Binding<URL>, isLoading: Binding<Bool>) {
        self._url = url
        self._isLoading = isLoading
        
        self.initialURL = url.wrappedValue
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let request = URLRequest(url: initialURL)
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(_ webView: WebViewRepresentable) {
            self.parent = webView
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            if webView.url != parent.initialURL {
                parent.url = webView.url ?? parent.initialURL
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
