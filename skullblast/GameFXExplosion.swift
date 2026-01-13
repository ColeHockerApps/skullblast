import Foundation
import CoreGraphics

struct GameFXExplosion: Hashable {

    struct Particle: Hashable {
        var id: UUID = UUID()
        var position: CGPoint
        var velocity: CGVector
        var radius: CGFloat
        var life: CGFloat
        var maxLife: CGFloat

        mutating func step(dt: CGFloat) {
            position.x += velocity.dx * dt
            position.y += velocity.dy * dt

            velocity.dx *= 0.985
            velocity.dy *= 0.985

            life = max(0, life - dt)
            radius *= 0.992
        }

        var t: CGFloat {
            guard maxLife > 0 else { return 1 }
            return min(1, max(0, 1 - (life / maxLife)))
        }

        var alpha: CGFloat {
            let x = 1 - t
            return x * x
        }

        var isAlive: Bool { life > 0.001 && radius > 0.2 }
    }

    var id: UUID = UUID()
    var origin: CGPoint
    var particles: [Particle]
    var startedAt: TimeInterval

    init(origin: CGPoint, now: TimeInterval, count: Int = 18, strength: CGFloat = 520, baseRadius: CGFloat = 7) {
        self.origin = origin
        self.startedAt = now
        self.particles = []

        let c = max(6, min(44, count))
        particles.reserveCapacity(c)

        for i in 0..<c {
            let a = (CGFloat(i) / CGFloat(c)) * CGFloat.pi * 2
            let jitter = (CGFloat((i * 37) % 11) - 5) * 0.06
            let ang = a + jitter

            let spJ = 0.78 + CGFloat((i * 17) % 9) * 0.03
            let speed = strength * spJ

            let vel = CGVector(dx: cos(ang) * speed, dy: sin(ang) * speed)
            let rJ = 0.75 + CGFloat((i * 13) % 7) * 0.05
            let life = CGFloat(0.55 + Double((i * 19) % 10) * 0.05)

            particles.append(
                Particle(
                    position: origin,
                    velocity: vel,
                    radius: baseRadius * rJ,
                    life: life,
                    maxLife: life
                )
            )
        }
    }

    mutating func step(dt: CGFloat) {
        for i in particles.indices {
            particles[i].step(dt: dt)
        }
        particles.removeAll { !$0.isAlive }
    }

    var isAlive: Bool { particles.isEmpty == false }
}
