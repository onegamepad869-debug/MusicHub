import Foundation

/// One tab in the app. Add a new entry to `all` to add another service.
struct MusicService {
    let title: String
    let symbol: String
    let url: URL
    let userAgent: String
}

extension MusicService {
    // Pretending to be Safari keeps Google sign-in working and stops the sites
    // from sending us to the App Store. Swap to `desktopSafari` if a site
    // shows a broken or "get the app" page.
    static let mobileSafari = "Mozilla/5.0 (iPhone; CPU iPhone OS 18_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Mobile/15E148 Safari/604.1"
    static let desktopSafari = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15"

    static let all: [MusicService] = [
        MusicService(
            title: "YouTube Music",
            symbol: "play.circle.fill",
            url: URL(string: "https://music.youtube.com")!,
            userAgent: mobileSafari
        ),
        MusicService(
            title: "SoundCloud",
            symbol: "cloud.fill",
            url: URL(string: "https://m.soundcloud.com")!,
            userAgent: mobileSafari
        ),
    ]
}
