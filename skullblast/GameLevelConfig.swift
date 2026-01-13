import Foundation
import CoreGraphics

struct GameLevelConfig: Equatable {

    struct PathPoint: Equatable {
        let position: CGPoint
    }

    let id: Int
    let path: [PathPoint]
    let initialChainLength: Int
    let availableColors: Int
    let chainSpeed: CGFloat

    static func defaultLevel() -> GameLevelConfig {
        GameLevelConfig(
            id: 1,
            path: [
                PathPoint(position: CGPoint(x: 40, y: 120)),
                PathPoint(position: CGPoint(x: 140, y: 160)),
                PathPoint(position: CGPoint(x: 260, y: 140)),
                PathPoint(position: CGPoint(x: 340, y: 220))
            ],
            initialChainLength: 12,
            availableColors: 4,
            chainSpeed: 140
        )
    }
}
