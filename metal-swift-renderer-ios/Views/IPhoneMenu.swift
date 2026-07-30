//
//  IPhoneMenu.swift
//  metal-swift-renderer-ios
//
//  Created by Mario Zuniga on 22/07/26.
//

import SwiftUI

struct IPhoneMenu: View {
    @EnvironmentObject var worldController: WorldController
    @EnvironmentObject var menuController: MenuController

    var body: some View {
        NavigationStack {
            MetalView(worldController: worldController)
                .ignoresSafeArea()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            menuController.isPresented = true
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
        }
        .sheet(isPresented: $menuController.isPresented) {
            SidebarMenu(worldController: worldController)
        }
    }
}
