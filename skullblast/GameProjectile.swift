import Foundation
import CoreGraphics

struct GameProjectile: Hashable, Identifiable {

    let id: UUID

    var position: CGPoint
    var velocity: CGVector
    var radius: CGFloat
    var colorIndex: Int

    let bornAt: TimeInterval
    let maxLife: TimeInterval
    var bouncesLeft: Int

    init(
        position: CGPoint,
        velocity: CGVector,
        radius: CGFloat,
        colorIndex: Int,
        bornAt: TimeInterval,
        maxLife: TimeInterval = 6.0,
        bouncesLeft: Int = 0
    ) {
        self.id = UUID()
        self.position = position
        self.velocity = velocity
        self.radius = radius
        self.colorIndex = colorIndex
        self.bornAt = bornAt
        self.maxLife = maxLife
        self.bouncesLeft = bouncesLeft
    }

    mutating func step(dt: CGFloat) {
        position.x += velocity.dx * dt
        position.y += velocity.dy * dt
    }

    func isExpired(now: TimeInterval) -> Bool {
        (now - bornAt) >= maxLife
    }

    mutating func bounce(horizontal: Bool = false, vertical: Bool = false, damp: CGFloat = 0.98) {
        guard bouncesLeft > 0 else { return }
        bouncesLeft -= 1

        if horizontal { velocity.dx = -velocity.dx }
        if vertical { velocity.dy = -velocity.dy }

        velocity.dx *= damp
        velocity.dy *= damp
    }

    static func == (lhs: GameProjectile, rhs: GameProjectile) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
