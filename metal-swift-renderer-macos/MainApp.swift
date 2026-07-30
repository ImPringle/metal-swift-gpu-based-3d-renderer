import SwiftUI

@main
struct MainApp: App {
    @StateObject private var worldController = WorldController()
    @StateObject private var menuController = MenuController()
    @StateObject private var windowController = WindowController()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(worldController)
                .environmentObject(menuController)
                .environmentObject(windowController)
        }
        .windowStyle(.titleBar)
    }
}
