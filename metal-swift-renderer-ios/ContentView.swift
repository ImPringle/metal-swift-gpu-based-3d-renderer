import SwiftUI

struct ContentView: View {
    @EnvironmentObject var menuController: MenuController
    @EnvironmentObject var worldController: WorldController
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            IPhoneMenu()
        } else {
            iPadMenu()
        }
        
        
        
        
        
        
    }
}
