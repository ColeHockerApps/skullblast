import Foundation
import CoreGraphics
import Combine

final class GameShooter: ObservableObject {

    @Published private(set) var angle: CGFloat = 0
    @Published private(set) var power: CGFloat = 0.7

    var minAngle: CGFloat = -CGFloat.pi * 0.45
    var maxAngle: CGFloat =  CGFloat.pi * 0.45

    var minPower: CGFloat = 0.25
    var maxPower: CGFloat = 1.0

    var muzzle: CGPoint = .zero
    var baseSpeed: CGFloat = 900

    private var cooldownUntil: TimeInterval = 0
    var cooldown: TimeInterval = 0.12

    func setMuzzle(_ point: CGPoint) {
        muzzle = point
    }

    func setAngle(_ radians: CGFloat) {
        angle = clamp(radians, minAngle, maxAngle)
    }

    func adjustAngle(delta: CGFloat) {
        setAngle(angle + delta)
    }

    func setPowerNormalized(_ value: CGFloat) {
        power = clamp(value, minPower, maxPower)
    }

    func canShoot(now: TimeInterval) -> Bool {
        now >= cooldownUntil
    }

    func shoot(kind: GameBall.Kind, now: TimeInterval, radius: CGFloat = 14) -> GameBall? {
        guard canShoot(now: now) else { return nil }

        cooldownUntil = now + cooldown

        let dir = CGVector(dx: cos(angle), dy: sin(angle))
        let speed = baseSpeed * power
        let velocity = CGVector(dx: dir.dx * speed, dy: dir.dy * speed)

        return GameBall(
            kind: kind,
            position: muzzle,
            velocity: velocity,
            radius: radius,
            isActive: true
        )
    }

    private func clamp(_ v: CGFloat, _ lo: CGFloat, _ hi: CGFloat) -> CGFloat {
        min(hi, max(lo, v))
    }
}
