import SwiftUI
import Combine

struct GameLoadingScreen: View {

    @State private var rotate: Double = 0
    @State private var pulse: Bool = false
    @State private var flame: CGFloat = 0
    @State private var flicker: Double = 0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            backgroundFire

            VStack(spacing: 28) {
                Spacer()

                skullCore

                loadingText

                Spacer()
            }
        }
        .onAppear {
            pulse = true

            withAnimation(
                Animation.linear(duration: 2.6)
                    .repeatForever(autoreverses: false)
            ) {
                rotate = 360
            }

            withAnimation(
                Animation.easeInOut(duration: 1.4)
                    .repeatForever(autoreverses: true)
            ) {
                flame = 1
            }

            withAnimation(
                Animation.easeInOut(duration: 0.12)
                    .repeatForever(autoreverses: true)
            ) {
                flicker = 1
            }
        }
    }

    private var skullCore: some View {
        ZStack {
            Circle()
                .stroke(Color.orange.opacity(0.35), lineWidth: 3)
                .frame(width: 96, height: 96)
                .rotationEffect(.degrees(rotate))

            Image(systemName: "skull.fill")
                .font(.system(size: 42, weight: .regular))
                .foregroundColor(Color.white.opacity(0.9))
                .scaleEffect(pulse ? 1.05 : 0.95)
                .shadow(color: Color.orange.opacity(0.9), radius: 18, x: 0, y: 0)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: pulse
                )

            fireRing
        }
    }

    private var fireRing: some View {
        Circle()
            .stroke(
                AngularGradient(
                    colors: [
                        Color.clear,
                        Color.orange.opacity(0.9),
                        Color.red.opacity(0.8),
                        Color.clear
                    ],
                    center: .center
                ),
                lineWidth: 6
            )
            .frame(width: 116, height: 116)
            .rotationEffect(.degrees(-rotate * 1.4))
            .blur(radius: 2)
            .opacity(0.8 + flame * 0.2)
    }

    private var loadingText: some View {
        Text("Loading")
            .font(.system(size: 15, weight: .medium, design: .rounded))
            .foregroundColor(Color.white.opacity(0.85))
            .tracking(1.2)
            .opacity(0.6 + flicker * 0.4)
    }

    private var backgroundFire: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                fireBlob(size: min(w, h) * 0.9, x: w * 0.2, y: h * 0.25)
                fireBlob(size: min(w, h) * 0.7, x: w * 0.8, y: h * 0.35)
                fireBlob(size: min(w, h) * 0.6, x: w * 0.45, y: h * 0.75)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private func fireBlob(size: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [
                        Color.orange.opacity(0.35),
                        Color.red.opacity(0.25),
                        Color.clear
                    ],
                    center: .center,
                    startRadius: 10,
                    endRadius: size * 0.6
                )
            )
            .frame(width: size, height: size)
            .position(x: x, y: y)
            .scaleEffect(0.95 + flame * 0.08)
            .blur(radius: 28)
            .blendMode(.screen)
    }
}
