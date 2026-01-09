import SwiftUI

struct ContentView: View {
    @State private var HUDctrl: HUDController = HUDController()
    
    var body: some View {
        ZStack {
            MetalView(HUDctrl: $HUDctrl)
                .ignoresSafeArea()
            HUD(HUDctrl: $HUDctrl)
        }
    }
}
