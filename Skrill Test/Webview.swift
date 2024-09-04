import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    var onNewWindow: (URL) -> Void
    @Binding var closeWebView: Bool
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebView

        init(parent: WebView) {
            self.parent = parent
        }

        // Detect new window requests and pass the URL to the parent
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            // When a new window is requested, extract the URL and send it to the parent
            if let url = navigationAction.request.url {
                DispatchQueue.main.async {
                    self.parent.onNewWindow(url) // Trigger new window creation in SwiftUI
                }
            }
            return nil // Return nil since we manage the window creation in SwiftUI
        }

        // Detect when the web content attempts to close the window
        func webViewDidClose(_ webView: WKWebView) {
            DispatchQueue.main.async {
                self.parent.closeWebView = true // Signal to close the sheet/modal
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        // Load the initial page
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Only handle new window navigation in updateUIView if necessary
    }
}
