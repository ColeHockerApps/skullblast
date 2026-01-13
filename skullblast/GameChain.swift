import Foundation

struct GameChain {

    private(set) var count: Int = 0
    private(set) var score: Int = 0

    mutating func reset() {
        count = 0
        score = 0
    }

    mutating func registerMerge(basePoints: Int) {
        count += 1
        let multiplier = 1 + min(count, 6)
        score += basePoints * multiplier
    }

    mutating func registerClear(pointsPerBall: Int, cleared: Int) {
        guard cleared > 0 else { return }
        let multiplier = 1 + min(count, 6)
        score += pointsPerBall * cleared * multiplier
    }

    func isActive() -> Bool {
        count > 0
    }
}
