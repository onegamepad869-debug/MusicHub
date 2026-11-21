import AVFoundation

/// Tells iOS that this app plays music, so audio keeps going on the lock screen
/// and in the background (together with UIBackgroundModes = audio in Info.plist).
enum AudioSession {
    static func activate() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("AudioSession: \(error)")
        }
    }
}
