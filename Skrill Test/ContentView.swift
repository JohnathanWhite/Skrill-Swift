import SwiftUI

struct ContentView: View {
    @State private var initialWebView: URL = URL(string: "add invoice url here example -> https://bitpay.com/invoice?v=4&id=U9F1Qa95gxU4xcYomyayam&lang=en-US")! // Initial web view URL
    @State private var newWebView: URL? // URL for the new web view
    @State private var isPresentingWebView: Bool = false // Controls when the sheet is shown
    @State private var closeWebView: Bool = false // Control for closing the second web view

    var body: some View {
        VStack {
            WebView(url: initialWebView, onNewWindow: { url in
                newWebView = url
                isPresentingWebView = true
            }, closeWebView: $closeWebView)
                .edgesIgnoringSafeArea(.all) // Make the web view full-screen

            .sheet(isPresented: $isPresentingWebView, onDismiss: {
                newWebView = nil
            }) {
                if let newWebViewURL = newWebView {
                    WebView(url: newWebViewURL, onNewWindow: { _ in }, closeWebView: $closeWebView)
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        // Close the sheet when the closeWebView flag is set
        .onChange(of: closeWebView) { shouldClose in
            if shouldClose {
                isPresentingWebView = false // Close the sheet
                closeWebView = false // Reset the flag
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

