import SwiftUI

struct ContentView: View {
    @EnvironmentObject var menuController: MenuController
    @EnvironmentObject var worldController: WorldController
    
    var body: some View {
        NavigationSplitView {
            SidebarMenu(worldController: worldController)
        } detail: {
            MetalView(worldController: worldController)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
        .inspector(isPresented: $menuController.isPresented) {
        }
    }
}
