import Combine
import SwiftUI

@MainActor
final class GameRouter: ObservableObject {

    enum Route: Hashable {
        case entry
        case intro
        case play
        case settings
        case privacy
    }

    @Published private(set) var stack: [Route] = [.entry]

    func reset(to route: Route = .entry) {
        stack = [route]
    }

    func go(_ route: Route) {
        stack.append(route)
    }

    func replaceTop(with route: Route) {
        guard stack.isEmpty == false else {
            stack = [route]
            return
        }
        stack.removeLast()
        stack.append(route)
    }

    func back() {
        guard stack.count > 1 else { return }
        stack.removeLast()
    }

    func popToRoot() {
        guard let first = stack.first else { return }
        stack = [first]
    }

    func isOn(_ route: Route) -> Bool {
        stack.last == route
    }
}
