import Foundation
import CoreGraphics

struct GameBall: Identifiable, Equatable {

    let id: UUID = UUID()

    enum Kind: Int, CaseIterable {
        case red
        case blue
        case green
        case yellow
        case purple
        case skull
        case fire
    }

    var kind: Kind
    var position: CGPoint
    var velocity: CGVector
    var radius: CGFloat
    var isActive: Bool
    var pathT: CGFloat

    init(
        kind: Kind,
        position: CGPoint,
        velocity: CGVector = .zero,
        radius: CGFloat = 16,
        isActive: Bool = true,
        pathT: CGFloat = 0
    ) {
        self.kind = kind
        self.position = position
        self.velocity = velocity
        self.radius = radius
        self.isActive = isActive
        self.pathT = pathT
    }

    mutating func update(delta: CGFloat) {
        guard isActive else { return }

        position.x += velocity.dx * delta
        position.y += velocity.dy * delta
    }

    mutating func moveAlongPath(_ path: GamePath, speed: CGFloat, delta: CGFloat) {
        guard isActive else { return }

        pathT += speed * delta
        pathT = min(1, pathT)
        position = path.position(at: pathT)
    }

    func collides(with other: GameBall) -> Bool {
        let dx = position.x - other.position.x
        let dy = position.y - other.position.y
        let dist = sqrt(dx * dx + dy * dy)
        return dist <= (radius + other.radius)
    }
}
