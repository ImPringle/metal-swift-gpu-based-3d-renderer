import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    @EnvironmentObject var windowController: WindowController
    var worldController: WorldController

    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this Mac.")
        }
        
        mtkView.device = device
        mtkView.autoResizeDrawable = true
        
        if let renderer = Renderer(mtkView, worldController, windowController) {
            context.coordinator.renderer = renderer
            mtkView.delegate = renderer
        }

        return mtkView
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
    }
    
    class Coordinator: NSObject {
        var renderer: Renderer?
    }
}
