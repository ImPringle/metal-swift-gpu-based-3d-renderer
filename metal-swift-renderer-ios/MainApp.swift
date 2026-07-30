//
//  metal_swift_renderer_iosApp.swift
//  metal-swift-renderer-ios
//
//  Created by Mario Zuniga on 21/07/26.
//

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
        
    }
}
