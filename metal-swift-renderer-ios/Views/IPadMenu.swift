//
//  iPadMenu.swift
//  metal-swift-renderer-ios
//
//  Created by Mario Zuniga on 22/07/26.
//

import SwiftUI

struct iPadMenu: View {
    @EnvironmentObject var worldController: WorldController
    @EnvironmentObject var menuController: MenuController
    
    var body: some View {
        NavigationSplitView {
            SidebarMenu(worldController: worldController)
        } detail: {
            MetalView(worldController: worldController)
                .ignoresSafeArea()
        }
    }
}
