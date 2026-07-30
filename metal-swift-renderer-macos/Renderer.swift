import Metal
import MetalKit
import QuartzCore
import CGMath

@Observable
final class Renderer: NSObject, MTKViewDelegate {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let mtkView: MTKView
    
    private var worldController: WorldController
    private var windowController: WindowController
    
    private var scene: RenderScene
    
    private var lastTime: Double = CACurrentMediaTime()
    private var lineVerticesNDC: [SIMD2<Float>] = []

    // Static floor grid on the xz plane.
//    private let grid: Grid
    
    // Default setting orientation facing front snoopy
    static let facingFront = Quaternion.fromAxisAngle(axis: Point3D(x: 0, y: 1, z: 0), angle: Float.pi)
    
    // Orientation (Quaternion specific)
    var orientation = Quaternion.identity().multiply(q2: facingFront)
    
    
    
    // Speeds
    private var speed: Float = 1.5
    private var rotSpeed: Float = 1.0
    private var scalingSpeed: Float = 0.5

    init?(_ mtkView: MTKView, _ worldController: WorldController, _ windowController: WindowController) {
        self.mtkView = mtkView
        self.device = mtkView.device!
        self.commandQueue = device.makeCommandQueue()!
        self.worldController = worldController
        self.windowController = windowController
        
        let newCube = Cube(device: device)
        let newGrid = Grid(device: device)
        let newScene = RenderScene(worldController: worldController)
        newScene.meshes.append(newGrid)
        newScene.meshes.append(newCube)
        
        self.scene = newScene

        let library = device.makeDefaultLibrary()
        let vs = library?.makeFunction(name: "vertex_main")
        let fs = library?.makeFunction(name: "fragment_main")

        let pipeline_descriptor = MTLRenderPipelineDescriptor()
        pipeline_descriptor.vertexFunction = vs
        pipeline_descriptor.fragmentFunction = fs
        pipeline_descriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat

        let vertex_descriptor = MTLVertexDescriptor()
        vertex_descriptor.attributes[0].format = .float4
        vertex_descriptor.attributes[0].offset = 0
        vertex_descriptor.attributes[0].bufferIndex = 0
        
        vertex_descriptor.attributes[1].format = .float4
        vertex_descriptor.attributes[1].offset = MemoryLayout<SIMD4<Float>>.stride
        vertex_descriptor.attributes[1].bufferIndex = 0
        
        vertex_descriptor.layouts[0].stride = MemoryLayout<CGVertex>.stride
        vertex_descriptor.layouts[0].stepFunction = .perVertex
        pipeline_descriptor.vertexDescriptor = vertex_descriptor

        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipeline_descriptor)
        } catch {
            print("[ERROR] Pipeline creation failed:", error)
            return nil
        }

        super.init()
    }

    private func update() {
        let now = CACurrentMediaTime()
        let dt = Float(now - lastTime)
        lastTime = now
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let pixelWidth = Float(size.width)
        let pixelHeight = Float(size.height)
        
        DispatchQueue.main.async { [weak self] in
            self?.worldController.aspect = pixelWidth / pixelHeight
        }
    }

    func draw(in view: MTKView) {
        update()
        
        guard let passDesc = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable,
              let cmd = commandQueue.makeCommandBuffer(),
              let enc = cmd.makeRenderCommandEncoder(descriptor: passDesc)
        else { return }

        enc.setRenderPipelineState(pipelineState)

        let viewMatrix = scene.GetViewMatrix()
        let aspect = worldController.aspect
        let projectionMatrix = simd_float4x4.perspective(
            fovRadians: degToRad(worldController.fov),
            aspectRatio: aspect,
            near: worldController.znear,
            far: worldController.zfar
        )
        
        for mesh in scene.meshes {
            let finalMVP = projectionMatrix * viewMatrix * mesh.modelMatrix
            var uniforms = CGUniforms(mvp: finalMVP)
            
            enc.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
            enc.setVertexBytes(&uniforms, length: MemoryLayout<CGUniforms>.stride, index: 1)
            
            enc.drawIndexedPrimitives(
                type: mesh.primitiveType,
                indexCount: mesh.indexCount,
                indexType: .uint16,
                indexBuffer: mesh.indexBuffer,
                indexBufferOffset: 0
            )
        }
        
        

        enc.endEncoding()
        cmd.present(drawable)
        cmd.commit()
    }
}
