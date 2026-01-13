import Combine
import UIKit

@MainActor
final class GameHapticsManager: ObservableObject {

    @Published var isEnabled: Bool = true

    private let light = UIImpactFeedbackGenerator(style: .light)
    private let medium = UIImpactFeedbackGenerator(style: .medium)
    private let heavy = UIImpactFeedbackGenerator(style: .heavy)

    private let select = UISelectionFeedbackGenerator()
    private let note = UINotificationFeedbackGenerator()

    init() {}

    func prepare() {
        guard isEnabled else { return }
        light.prepare()
        medium.prepare()
        heavy.prepare()
        select.prepare()
        note.prepare()
    }

    func tapLight() {
        guard isEnabled else { return }
        light.impactOccurred(intensity: 0.85)
    }

    func tapMedium() {
        guard isEnabled else { return }
        medium.impactOccurred(intensity: 0.95)
    }

    func tapHeavy() {
        guard isEnabled else { return }
        heavy.impactOccurred(intensity: 1.0)
    }

    func selectTick() {
        guard isEnabled else { return }
        select.selectionChanged()
    }

    func success() {
        guard isEnabled else { return }
        note.notificationOccurred(.success)
    }

    func warning() {
        guard isEnabled else { return }
        note.notificationOccurred(.warning)
    }

    func error() {
        guard isEnabled else { return }
        note.notificationOccurred(.error)
    }
}
