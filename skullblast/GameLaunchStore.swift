import Foundation
import Combine

@MainActor
final class GameLaunchStore: ObservableObject {

    @Published var playPoint: URL
    @Published var privacyPoint: URL

    var mainPoint: URL { playPoint }

    private let playKey = "game.play"
    private let privacyKey = "game.privacy"
    private let resumeKey = "game.resume"
    private let marksKey = "game.marks"

    private var didStoreResume = false

    private static let defaultPlay = "https://adamehgames.github.io/skullblast/"
    private static let defaultPrivacy = "https://adamehgames.github.io/skullblast-terms"

    init() {
        let defaults = UserDefaults.standard

        if let saved = defaults.string(forKey: playKey),
           let v = URL(string: saved) {
            playPoint = v
        } else {
            playPoint = URL(string: Self.defaultPlay)!
        }

        if let saved = defaults.string(forKey: privacyKey),
           let v = URL(string: saved) {
            privacyPoint = v
        } else {
            privacyPoint = URL(string: Self.defaultPrivacy)!
        }
    }

    func updatePlay(_ value: String) {
        guard let v = URL(string: value) else { return }
        playPoint = v
        UserDefaults.standard.set(value, forKey: playKey)
    }

    func updatePrivacy(_ value: String) {
        guard let v = URL(string: value) else { return }
        privacyPoint = v
        UserDefaults.standard.set(value, forKey: privacyKey)
    }

    func storeResumeIfNeeded(_ point: URL) {
        guard didStoreResume == false else { return }
        didStoreResume = true

        let defaults = UserDefaults.standard
        if defaults.string(forKey: resumeKey) != nil { return }
        defaults.set(point.absoluteString, forKey: resumeKey)
    }

    func restoreResume() -> URL? {
        let defaults = UserDefaults.standard
        if let saved = defaults.string(forKey: resumeKey),
           let v = URL(string: saved) {
            return v
        }
        return nil
    }

    func saveMarks(_ items: [[String: Any]]) {
        UserDefaults.standard.set(items, forKey: marksKey)
    }

    func loadMarks() -> [[String: Any]]? {
        UserDefaults.standard.array(forKey: marksKey) as? [[String: Any]]
    }

    func resetAll() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: playKey)
        defaults.removeObject(forKey: privacyKey)
        defaults.removeObject(forKey: resumeKey)
        defaults.removeObject(forKey: marksKey)
        didStoreResume = false

        playPoint = URL(string: Self.defaultPlay)!
        privacyPoint = URL(string: Self.defaultPrivacy)!
    }

    func normalize(_ u: URL) -> String {
        var s = u.absoluteString
        while s.count > 1, s.hasSuffix("/") { s.removeLast() }
        return s
    }
}
