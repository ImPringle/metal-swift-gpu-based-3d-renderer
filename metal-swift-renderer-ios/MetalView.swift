//
//  MetalView.swift
//  metal-swift-renderer-ios
//
//  Created by Mario Zuniga on 22/07/26.
//

import SwiftUI
import MetalKit

struct MetalView: UIViewRepresentable {
    @EnvironmentObject var windowController: WindowController
    var worldController: WorldController

    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<MetalView>) -> MTKView {
        let mtkView = MTKView()
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this Mac.")
        }
        
        mtkView.device = device
        mtkView.autoResizeDrawable = true
        mtkView.depthStencilPixelFormat = .depth32Float
        
        if let renderer = Renderer(mtkView, worldController, windowController) {
            context.coordinator.renderer = renderer
            mtkView.delegate = renderer
        }

        return mtkView
    }

    func updateUIView(_ uiView: MTKView, context: UIViewRepresentableContext<MetalView>) {
    }
    
    class Coordinator: NSObject {
        var renderer: Renderer?
    }
}
