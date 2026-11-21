import WebKit

/// JavaScript injected into every page before the site's own code runs.
enum Scripts {
    static let all: [WKUserScript] = [keepPlaying, youtubeAds]

    /// The sites pause music when they think the page is hidden (screen locked,
    /// app in the background). Make the page always look visible.
    static let keepPlaying = WKUserScript(source: """
    (function () {
      var visible = function (prop, value) {
        Object.defineProperty(document, prop, { get: function () { return value; }, configurable: true });
      };
      visible('hidden', false);
      visible('webkitHidden', false);
      visible('visibilityState', 'visible');
      visible('webkitVisibilityState', 'visible');
      var swallow = function (e) { e.stopImmediatePropagation(); };
      document.addEventListener('visibilitychange', swallow, true);
      document.addEventListener('webkitvisibilitychange', swallow, true);
      window.addEventListener('pagehide', swallow, true);
      window.addEventListener('blur', swallow, true);
    })();
    """, injectionTime: .atDocumentStart, forMainFrameOnly: true)

    /// YouTube serves ads from its own servers, so network blocking is not enough.
    /// Strip the ad data from the player's responses, and skip anything that slips through.
    static let youtubeAds = WKUserScript(source: """
    (function () {
      if (location.hostname.indexOf('youtube.com') === -1) return;

      var AD_KEYS = ['adPlacements', 'playerAds', 'adSlots', 'adBreakHeartbeatParams'];
      var strip = function (obj) {
        if (!obj || typeof obj !== 'object') return obj;
        AD_KEYS.forEach(function (key) { if (key in obj) delete obj[key]; });
        if (obj.playerResponse) strip(obj.playerResponse);
        return obj;
      };

      var parse = JSON.parse;
      JSON.parse = function () { return strip(parse.apply(this, arguments)); };
      var json = Response.prototype.json;
      Response.prototype.json = function () { return json.apply(this, arguments).then(strip); };

      setInterval(function () {
        var skip = document.querySelector('.ytp-ad-skip-button, .ytp-ad-skip-button-modern, .ytp-skip-ad-button');
        if (skip) skip.click();
        var ad = document.querySelector('.ad-showing video');
        if (ad && isFinite(ad.duration)) ad.currentTime = ad.duration;
      }, 500);
    })();
    """, injectionTime: .atDocumentStart, forMainFrameOnly: true)
}
