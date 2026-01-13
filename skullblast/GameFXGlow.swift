import Foundation
import CoreGraphics

struct GameFXGlow: Hashable {

    struct Ring: Hashable {
        var id: UUID = UUID()
        var center: CGPoint
        var radius: CGFloat
        var thickness: CGFloat
        var life: CGFloat
        var maxLife: CGFloat
        var growth: CGFloat

        mutating func step(dt: CGFloat) {
            radius += growth * dt
            thickness = max(0.6, thickness * 0.992)
            life = max(0, life - dt)
        }

        var t: CGFloat {
            guard maxLife > 0 else { return 1 }
            return min(1, max(0, 1 - (life / maxLife)))
        }

        var alpha: CGFloat {
            let x = 1 - t
            return x * x
        }

        var isAlive: Bool { life > 0.001 }
    }

    var id: UUID = UUID()
    var rings: [Ring]
    var startedAt: TimeInterval

    init(center: CGPoint, now: TimeInterval, ringsCount: Int = 2, startRadius: CGFloat = 16, growth: CGFloat = 240) {
        self.startedAt = now
        self.rings = []

        let n = max(1, min(4, ringsCount))
        rings.reserveCapacity(n)

        for i in 0..<n {
            let mul = 1 + CGFloat(i) * 0.22
            let life = CGFloat(0.38 + Double(i) * 0.10)
            rings.append(
                Ring(
                    center: center,
                    radius: startRadius * mul,
                    thickness: 5.5 - CGFloat(i) * 1.0,
                    life: life,
                    maxLife: life,
                    growth: growth * (0.9 + CGFloat(i) * 0.08)
                )
            )
        }
    }

    mutating func step(dt: CGFloat) {
        for i in rings.indices {
            rings[i].step(dt: dt)
        }
        rings.removeAll { !$0.isAlive }
    }

    var isAlive: Bool { rings.isEmpty == false }
}
