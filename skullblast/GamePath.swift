import Foundation
import CoreGraphics

struct GamePath {

    struct Node: Equatable {
        let position: CGPoint
        let t: CGFloat
    }

    let nodes: [Node]

    init(points: [CGPoint]) {
        guard points.count >= 2 else {
            self.nodes = []
            return
        }

        var built: [Node] = []
        let count = points.count

        for i in 0..<count {
            let t = CGFloat(i) / CGFloat(count - 1)
            built.append(
                Node(
                    position: points[i],
                    t: t
                )
            )
        }

        self.nodes = built
    }

    func position(at t: CGFloat) -> CGPoint {
        guard nodes.count >= 2 else {
            return nodes.first?.position ?? .zero
        }

        let clamped = max(0, min(1, t))
        let scaled = clamped * CGFloat(nodes.count - 1)
        let i = Int(floor(scaled))
        let frac = scaled - CGFloat(i)

        if i >= nodes.count - 1 {
            return nodes.last!.position
        }

        let a = nodes[i].position
        let b = nodes[i + 1].position

        return CGPoint(
            x: a.x + (b.x - a.x) * frac,
            y: a.y + (b.y - a.y) * frac
        )
    }
}
