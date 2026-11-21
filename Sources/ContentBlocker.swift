import WebKit

/// Network-level ad blocking, shared by every tab. Compiled once, then reused.
enum ContentBlocker {
    private static var compiled: WKContentRuleList?
    private static var isCompiling = false
    private static var waiting: [(WKContentRuleList?) -> Void] = []

    static func load(_ completion: @escaping (WKContentRuleList?) -> Void) {
        if let compiled {
            completion(compiled)
            return
        }
        waiting.append(completion)
        guard !isCompiling else { return }
        isCompiling = true

        WKContentRuleListStore.default().compileContentRuleList(forIdentifier: "MusicHubAdBlock", encodedContentRuleList: rules) { list, error in
            if let error {
                print("ContentBlocker: \(error)")
            }
            ContentBlocker.compiled = list
            ContentBlocker.isCompiling = false
            let callbacks = ContentBlocker.waiting
            ContentBlocker.waiting = []
            callbacks.forEach { $0(list) }
        }
    }

    private static let blockedPatterns = [
        // Google / YouTube ads
        "^https?://[^/]*doubleclick\\.net/",
        "^https?://[^/]*googlesyndication\\.com/",
        "^https?://[^/]*googleadservices\\.com/",
        "^https?://[^/]*adservice\\.google\\.",
        "^https?://[^/]*youtube\\.com/pagead/",
        "^https?://[^/]*youtube\\.com/api/stats/ads",
        "^https?://[^/]*youtube\\.com/ptracking",
        "^https?://[^/]*youtube\\.com/get_midroll_",
        // SoundCloud audio ads and trackers
        "^https?://[^/]*adswizz\\.com/",
        "^https?://[^/]*promoted\\.soundcloud\\.com/",
        "^https?://[^/]*moatads\\.com/",
        "^https?://[^/]*doubleverify\\.com/",
        "^https?://[^/]*scorecardresearch\\.com/",
        "^https?://[^/]*quantserve\\.com/",
        "^https?://[^/]*pubmatic\\.com/",
        "^https?://[^/]*rubiconproject\\.com/",
        "^https?://[^/]*amazon-adsystem\\.com/",
    ]

    private static var rules: String {
        let entries = blockedPatterns.map { pattern in
            ["trigger": ["url-filter": pattern], "action": ["type": "block"]]
        }
        let data = try! JSONSerialization.data(withJSONObject: entries)
        return String(data: data, encoding: .utf8)!
    }
}
