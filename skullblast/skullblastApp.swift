import SwiftUI
import Combine

@main
struct GameApp: App {

    @UIApplicationDelegateAdaptor(GameFlowDelegate.self) private var flow

    @StateObject private var router = GameRouter()
    @StateObject private var launch = GameLaunchStore()
    @StateObject private var session = GameSessionState()
    @StateObject private var orientation = GameOrientationManager()

    var body: some Scene {
        WindowGroup {
            GameEntryScreen()
                .environmentObject(router)
                .environmentObject(launch)
                .environmentObject(session)
                .environmentObject(orientation)
        }
    }
}
