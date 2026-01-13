import Combine
import SwiftUI

struct GamePlayContainer: View {

    @EnvironmentObject private var router: GameRouter
    @EnvironmentObject private var launch: GameLaunchStore
    @EnvironmentObject private var session: GameSessionState

    @StateObject private var model = GamePlayContainerModel()

    let onReady: () -> Void

    init(onReady: @escaping () -> Void) {
        self.onReady = onReady
    }

    var body: some View {
        let start = launch.restoreResume() ?? launch.playPoint

        ZStack {
            Color.black.ignoresSafeArea()

            GamePlayView(
                startPoint: start,
                launch: launch,
                session: session
            ) {
                model.markReady()
                onReady()
            }
            .opacity(model.fadeIn ? 1 : 0)
            .animation(.easeOut(duration: 0.32), value: model.fadeIn)

            if model.isReady == false {
                loadingOverlay
            }

            Color.black
                .opacity(model.dimLayer)
                .ignoresSafeArea()
                .allowsHitTesting(false)
                .animation(.easeOut(duration: 0.22), value: model.dimLayer)
        }
        .onAppear {
            model.onAppear()
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.18)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                GameSkullFlameOrbit()
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.white.opacity(0.10), lineWidth: 1)
                    )
            )
        }
        .transition(.opacity)
    }
}

@MainActor
final class GamePlayContainerModel: ObservableObject {

    @Published var isReady: Bool = false
    @Published var fadeIn: Bool = false
    @Published var dimLayer: Double = 1.0

    func onAppear() {
        isReady = false
        fadeIn = false
        dimLayer = 1.0

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.10) { [weak self] in
            self?.dimLayer = 0.0
        }
    }

    func markReady() {
        guard isReady == false else { return }
        isReady = true
        fadeIn = true
    }
}

private struct GameSkullFlameOrbit: View {

    @State private var spin: Double = 0
    @State private var pulse: Bool = false

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.14), lineWidth: 2.5)
                .frame(width: 54, height: 54)

            Image(systemName: "skull.fill")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.white.opacity(pulse ? 0.95 : 0.70))
                .scaleEffect(pulse ? 1.02 : 0.96)

            Image(systemName: "flame.fill")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.white.opacity(0.85))
                .offset(y: -26)
                .rotationEffect(.degrees(spin))
        }
        .onAppear {
            withAnimation(.linear(duration: 1.05).repeatForever(autoreverses: false)) {
                spin = 360
            }
            withAnimation(.easeInOut(duration: 0.85).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
