import Foundation
import Combine
import CoreGraphics
import QuartzCore

@MainActor
final class GameEngine: ObservableObject {

    struct Ball: Identifiable, Equatable {
        let id: UUID
        var position: CGPoint
        var velocity: CGVector
        var radius: CGFloat
        var colorIndex: Int
    }

    @Published private(set) var balls: [Ball] = []
    @Published private(set) var isRunning: Bool = false

    private var lastUpdate: TimeInterval = 0
    private let speed: CGFloat = 140

    init() {}

    func start() {
        balls.removeAll()
        spawnInitialChain()
        isRunning = true
        lastUpdate = CACurrentMediaTime()
    }

    func stop() {
        isRunning = false
    }

    func update() {
        guard isRunning else { return }

        let now = CACurrentMediaTime()
        let dt = CGFloat(now - lastUpdate)
        lastUpdate = now

        for i in balls.indices {
            balls[i].position.x += balls[i].velocity.dx * dt
            balls[i].position.y += balls[i].velocity.dy * dt
        }
    }

    func fireBall(from point: CGPoint, direction: CGVector, colorIndex: Int) {
        let v = normalize(direction)
        let ball = Ball(
            id: UUID(),
            position: point,
            velocity: CGVector(dx: v.dx * speed, dy: v.dy * speed),
            radius: 12,
            colorIndex: colorIndex
        )
        balls.append(ball)
    }

    private func spawnInitialChain() {
        let count = 12
        for i in 0..<count {
            let ball = Ball(
                id: UUID(),
                position: CGPoint(x: 40 + CGFloat(i) * 26, y: 120),
                velocity: CGVector(dx: speed * 0.35, dy: 0),
                radius: 12,
                colorIndex: i % 4
            )
            balls.append(ball)
        }
    }

    private func normalize(_ v: CGVector) -> CGVector {
        let len = sqrt(v.dx * v.dx + v.dy * v.dy)
        guard len > 0.0001 else { return .zero }
        return CGVector(dx: v.dx / len, dy: v.dy / len)
    }
}
