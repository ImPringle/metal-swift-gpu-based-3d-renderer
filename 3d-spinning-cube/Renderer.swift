import Metal
import MetalKit
import QuartzCore
import MathCore

@Observable
final class Renderer: NSObject, MTKViewDelegate {

    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    
    private var lastTime: Double = CACurrentMediaTime()
    private var lineVerticesNDC: [SIMD2<Float>] = []
    
    // Flags
    private var flipY = true
    var useQuaternions = false
    
    // Input state
    var moveForward: Bool = false
    var moveBackward: Bool = false
    var moveLeft: Bool = false
    var moveRight: Bool = false
    var moveUp: Bool = false
    var moveDown: Bool = false
    var rZClockwise: Bool = false
    var rZNClockwise: Bool = false
    var rXClockwise: Bool = false
    var rXNClockwise: Bool = false
    var rYClockwise: Bool = false
    var rYNClockwise: Bool = false
    var scalingUp: Bool = false
    var scalingDown: Bool = false
    var SpinXZ: Bool = false

    // Translation's deltas
    var dX: Float = 0.0
    var dY: Float = 0.0
    var dZ: Float = 1.0
    
    // Axis angles
    var aX: Float = 0.0
    var aY: Float = Float.pi
    var aZ: Float = 0.0
    
    // Scale
    var scale: Float = 1.0
    
    // Default setting orientation facing front snoopy
    static let facingFront = Quaternion.fromAxisAngle(axis: Point3D(x: 0, y: 1, z: 0), angle: Float.pi)
    
    // Orientation (Quaternion specific)
    var orientation = Quaternion.identity().multiply(q2: facingFront)
    
    
    
    // Speeds
    private var speed: Float = 1.5
    private var rotSpeed: Float = 1.0
    private var scalingSpeed: Float = 0.5

    init?(mtkView: MTKView) {
        guard let dev = mtkView.device,
              let queue = dev.makeCommandQueue()
        else { return nil }

        self.device = dev
        self.commandQueue = queue

        let library = dev.makeDefaultLibrary()
        let vs = library?.makeFunction(name: "vs_main")
        let fs = library?.makeFunction(name: "fs_main")

        let desc = MTLRenderPipelineDescriptor()
        desc.vertexFunction = vs
        desc.fragmentFunction = fs
        desc.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat

        let vDesc = MTLVertexDescriptor()
        vDesc.attributes[0].format = .float2
        vDesc.attributes[0].offset = 0
        vDesc.attributes[0].bufferIndex = 0
        vDesc.layouts[0].stride = MemoryLayout<SIMD2<Float>>.stride
        desc.vertexDescriptor = vDesc

        do {
            self.pipelineState = try dev.makeRenderPipelineState(descriptor: desc)
        } catch {
            print("[ERROR] Pipeline creation failed:", error)
            return nil
        }

        super.init()
        lineVerticesNDC.reserveCapacity(SnoopyModel.edges.count * 2)
    }

    private func update() {
        let now = CACurrentMediaTime()
        let dt = Float(now - lastTime)
        lastTime = now
        
        let qrx = (rXClockwise ? 1 : 0) - (rXNClockwise ? 1 : 0)
        let qry = (rYClockwise ? 1 : 0) - (rYNClockwise ? 1 : 0)
        let qrz = (rZClockwise ? 1 : 0) - (rZNClockwise ? 1 : 0)
        
        
        if moveForward {dZ += speed * dt}
        if moveBackward {dZ -= speed * dt}
        if moveRight {dX += speed * dt}
        if moveLeft {dX -= speed * dt}
        if moveUp {dY += speed * dt}
        if moveDown {dY -= speed * dt}
        if rXClockwise {aX += rotSpeed * dt}
        if rXNClockwise {aX -= rotSpeed * dt}
        if rYClockwise {aY += rotSpeed * dt}
        if rYNClockwise {aY -= rotSpeed * dt}
        if rZClockwise {aZ += rotSpeed * dt}
        if rZNClockwise {aZ -= rotSpeed * dt}
        if scalingUp {scale += scalingSpeed * dt}
        if scalingDown {scale -= scalingSpeed * dt}
        if SpinXZ {aY += rotSpeed * dt}
        
        
        // updating quaternions by its deltas
        if qrx != 0 {
            let dq = Quaternion.fromAxisAngle(axis: Point3D(x: 1, y: 0, z: 0), angle: Float(qrx) * rotSpeed * dt)
            orientation = dq.multiply(q2: orientation)
        }
        
        if qry != 0 {
            let dq = Quaternion.fromAxisAngle(axis: Point3D(x: 0, y: 1, z: 0), angle: Float(qry) * rotSpeed * dt)
            orientation = dq.multiply(q2: orientation)
        }
        
        if qrz != 0 {
            let dq = Quaternion.fromAxisAngle(axis: Point3D(x: 0, y: 0, z: 1), angle: Float(qrz) * rotSpeed * dt)
            orientation = dq.multiply(q2: orientation)
        }
        
    }

    private func rebuildLineList() {
        let R: Mat3 = orientation.toRotationMatrix()
        let projected = projectVertices(SnoopyModel.vertices, aX: aX, aY: aY, aZ: aZ, dX: dX, dY: dY, dZ: dZ, rotation: R, scale: scale, flipY: flipY, useQuats: useQuaternions)

        lineVerticesNDC.removeAll(keepingCapacity: true)

        for (a, b) in SnoopyModel.edges {
            let pa = projected[a]
            let pb = projected[b]

            let A = SIMD2<Float>(pa.x, -pa.y)
            let B = SIMD2<Float>(pb.x, -pb.y)

            lineVerticesNDC.append(A)
            lineVerticesNDC.append(B)
        }
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }

    func draw(in view: MTKView) {
        update()
        rebuildLineList()

        guard let passDesc = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable,
              let cmd = commandQueue.makeCommandBuffer(),
              let enc = cmd.makeRenderCommandEncoder(descriptor: passDesc)
        else { return }

        enc.setRenderPipelineState(pipelineState)

        let byteCount = lineVerticesNDC.count * MemoryLayout<SIMD2<Float>>.stride
        let vbuf = device.makeBuffer(bytes: lineVerticesNDC,
                                     length: byteCount,
                                     options: .storageModeShared)
        enc.setVertexBuffer(vbuf, offset: 0, index: 0)
        enc.drawPrimitives(type: .line, vertexStart: 0, vertexCount: lineVerticesNDC.count)

        enc.endEncoding()
        cmd.present(drawable)
        cmd.commit()
    }
}
