import SwiftUI
import Combine
import UIKit

@MainActor
final class GameOrientationManager: ObservableObject {

    enum Mode {
        case flexible
        case portrait
        case landscape
    }

    @Published private(set) var mode: Mode = .flexible
    @Published private(set) var activeValue: URL? = nil

    init() {}

    func allowFlexible() {
        mode = .flexible
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func lockPortrait() {
        mode = .portrait
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func lockLandscape() {
        mode = .landscape
        UIViewController.attemptRotationToDeviceOrientation()
    }

    func setActiveValue(_ value: URL?) {
        activeValue = normalizeTrailingSlash(value)
    }

    private func normalizeTrailingSlash(_ url: URL?) -> URL? {
        guard let url else { return nil }

        let scheme = url.scheme?.lowercased() ?? ""
        guard scheme == "http" || scheme == "https" else { return url }

        guard var c = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }

        if c.path.count > 1, c.path.hasSuffix("/") {
            while c.path.count > 1, c.path.hasSuffix("/") {
                c.path.removeLast()
            }
        }

        return c.url ?? url
    }

    var interfaceMask: UIInterfaceOrientationMask {
        switch mode {
        case .flexible:
            return [.portrait, .landscapeLeft, .landscapeRight]
        case .portrait:
            return [.portrait]
        case .landscape:
            return [.landscapeLeft, .landscapeRight]
        }
    }
}
