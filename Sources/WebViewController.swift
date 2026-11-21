import UIKit
import WebKit

final class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    private let service: MusicService
    private var webView: WKWebView!

    init(service: MusicService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: service.title, image: UIImage(systemName: service.symbol), selectedImage: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = .default()
        config.allowsInlineMediaPlayback = true
        config.allowsPictureInPictureMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        for script in Scripts.all {
            config.userContentController.addUserScript(script)
        }

        webView = WKWebView(frame: .zero, configuration: config)
        webView.customUserAgent = service.userAgent
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ContentBlocker.load { [weak self] ruleList in
            guard let self else { return }
            if let ruleList {
                self.webView.configuration.userContentController.add(ruleList)
            }
            self.goHome()
        }
    }

    func goHome() {
        webView.load(URLRequest(url: service.url))
    }

    // MARK: - WKNavigationDelegate

    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        // Block "open in app" redirects (youtubemusic://, itms-apps://, App Store pages).
        let scheme = url.scheme?.lowercased() ?? ""
        let isWeb = ["http", "https", "about", "blob", "data"].contains(scheme)
        let isAppStore = url.host?.hasSuffix("apps.apple.com") ?? false
        decisionHandler(isWeb && !isAppStore ? .allow : .cancel)
    }

    // iOS sometimes kills the page while the app is in the background; bring it back.
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        webView.reload()
    }

    // MARK: - WKUIDelegate

    // Links and sign-in popups that want a new window open in the same tab instead.
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
