import SwiftUI
import MetalKit

struct MetalView: NSViewRepresentable {
    @Binding var HUDctrl: HUDController
    func makeNSView(context: Context) -> MTKView {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this Mac.")
        }

        let view = InputMTKView(frame: .zero, device: device)
        let renderer = Renderer(mtkView: view)
        
        view.colorPixelFormat = .bgra8Unorm
        view.clearColor = MTLClearColorMake(0, 0, 0, 1)

        view.preferredFramesPerSecond = 60
        view.enableSetNeedsDisplay = false
        view.isPaused = false

        context.coordinator.renderer = renderer
        view.renderer = renderer
        view.delegate = renderer
        HUDctrl.renderer = renderer
        
        DispatchQueue.main.async {
            view.window?.makeFirstResponder(view)
        }

        return view
    }

    func updateNSView(_ nsView: MTKView, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator {
        var renderer: Renderer?
    }
}

final class InputMTKView: MTKView {
    weak var renderer: Renderer?
    
    override var acceptsFirstResponder: Bool { true }

    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 13:    // W
            renderer?.moveForward = true
            break
        case 1:     // S
            renderer?.moveBackward = true
            break
        case 0:     // A
            renderer?.moveLeft = true
            break
        case 2:     // D
            renderer?.moveRight = true
            break
        case 126:   // ArrowUp
            renderer?.moveDown = true
            break
        case 125:   // ArrowDown
            renderer?.moveUp = true
            break
        case 34:    // I
            renderer?.rXNClockwise = true
            break
        case 40:    // K
            renderer?.rXClockwise = true
            break
        case 31:    // O
            renderer?.rZClockwise = true
            break
        case 32:    // U
            renderer?.rZNClockwise = true
        case 37:    // L
            renderer?.rYClockwise = true
            break
        case 38:    // J
            renderer?.rYNClockwise = true
            break
        case 124:   // ArrowLeft
            renderer?.scalingUp = true
            break
        case 123:   // ArrowRight
            renderer?.scalingDown = true
            break
        case 15:
            renderer?.SpinXZ.toggle()
            break
        case 53:
            NSApp.terminate(nil)
            break
        default:
            print("keyCode:", event.keyCode)
            super.keyDown(with: event)
        }
    }
    
    override func keyUp(with event: NSEvent) {
        switch event.keyCode {
        case 13:    // W
            renderer?.moveForward = false
            break
        case 1:     // S
            renderer?.moveBackward = false
            break
        case 0:     // A
            renderer?.moveLeft = false
            break
        case 2:     // D
            renderer?.moveRight = false
            break
        case 126:   // ArrowUp
            renderer?.moveDown = false
            break
        case 125:   // ArrowDown
            renderer?.moveUp = false
            break
        case 34:    // I
            renderer?.rXNClockwise = false
            break
        case 40:    // K
            renderer?.rXClockwise = false
            break
        case 31:    // O
            renderer?.rZClockwise = false
            break
        case 32:    // U
            renderer?.rZNClockwise = false
        case 37:    // L
            renderer?.rYClockwise = false
            break
        case 38:    // J
            renderer?.rYNClockwise = false
            break
        case 124:   // ArrowLeft
            renderer?.scalingUp = false
            break
        case 123:   // ArrowRight
            renderer?.scalingDown = false
            break
        default:
            super.keyUp(with: event)
        }
    }
}
