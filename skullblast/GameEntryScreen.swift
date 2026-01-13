import SwiftUI
import Combine

struct GameEntryScreen: View {

    @EnvironmentObject private var router: GameRouter
    @EnvironmentObject private var launch: GameLaunchStore
    @EnvironmentObject private var session: GameSessionState
    @EnvironmentObject private var orientation: GameOrientationManager

    @State private var showLoading: Bool = true
    @State private var minTimePassed: Bool = false
    @State private var surfaceReady: Bool = false
    @State private var pendingURL: URL? = nil
    @State private var didApplyRotationRule: Bool = false

    var body: some View {
        ZStack {
            GamePlayContainer {
                surfaceReady = true
                applyRotationIfPossible()
                tryFinishLoading()
            }
            .opacity(showLoading ? 0 : 1)
            .animation(.easeOut(duration: 0.35), value: showLoading)

            if showLoading {
                GameLoadingScreen()
                    .transition(.opacity)
            }
        }
        .onAppear {
            orientation.allowFlexible()

            showLoading = true
            minTimePassed = false
            surfaceReady = false
            pendingURL = nil
            didApplyRotationRule = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.2) {
                minTimePassed = true
                applyRotationIfPossible()
                tryFinishLoading()
            }
        }
        .onReceive(orientation.$activeValue) { next in
            pendingURL = next
            applyRotationIfPossible()
        }
    }

    private func applyRotationIfPossible() {
        guard didApplyRotationRule == false else { return }
        guard minTimePassed && surfaceReady else { return }
        guard let next = pendingURL else { return }

        if isSame(next, launch.mainPoint) {
            GameFlowDelegate.shared?.forceLandscape()
        } else {
            GameFlowDelegate.shared?.clearForced()
        }

        didApplyRotationRule = true
    }

    private func tryFinishLoading() {
        guard minTimePassed && surfaceReady else { return }
        withAnimation(.easeOut(duration: 0.35)) {
            showLoading = false
        }
    }

    private func isSame(_ a: URL, _ b: URL) -> Bool {
        normalize(a) == normalize(b)
    }

    private func normalize(_ u: URL) -> String {
        var s = u.absoluteString
        while s.count > 1, s.hasSuffix("/") { s.removeLast() }
        return s
    }
}
