import Metal
import MetalKit
import QuartzCore
import CGMath

@Observable
final class Renderer: NSObject, MTKViewDelegate {
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let pipelineState: MTLRenderPipelineState
    private let depthStencilState: MTLDepthStencilState
    private let mtkView: MTKView
    
    private var worldController: WorldController
    private var windowController: WindowController
    
    private var scene: RenderScene
    
    private var lastTime: Double = CACurrentMediaTime()
    private var lineVerticesNDC: [SIMD2<Float>] = []
    
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
        
        let cubes = worldController.generateRandomCubes(device: device, 10000, 50)
//        let newGrid = Grid(device: device)
        let newScene = RenderScene(worldController: worldController)
//        newScene.meshes.append(newGrid)
        newScene.meshes = cubes
        
        self.scene = newScene

        let library = device.makeDefaultLibrary()
        let vs = library?.makeFunction(name: "vertex_main")
        let fs = library?.makeFunction(name: "fragment_main")

        let pipeline_descriptor = MTLRenderPipelineDescriptor()
        pipeline_descriptor.vertexFunction = vs
        pipeline_descriptor.fragmentFunction = fs
        pipeline_descriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipeline_descriptor.depthAttachmentPixelFormat = mtkView.depthStencilPixelFormat

        let vertex_descriptor = MTLVertexDescriptor()
        vertex_descriptor.attributes[0].format = .float4
        vertex_descriptor.attributes[0].offset = 0
        vertex_descriptor.attributes[0].bufferIndex = 0
        
        vertex_descriptor.attributes[1].format = .float3
        vertex_descriptor.attributes[1].offset = MemoryLayout<CGVertex>.offset(of: \.normal)!
        vertex_descriptor.attributes[1].bufferIndex = 0
        
        vertex_descriptor.attributes[2].format = .float4
        vertex_descriptor.attributes[2].offset = MemoryLayout<CGVertex>.offset(of: \.color)!
        vertex_descriptor.attributes[2].bufferIndex = 0
        
        vertex_descriptor.layouts[0].stride = MemoryLayout<CGVertex>.stride
        vertex_descriptor.layouts[0].stepFunction = .perVertex
        pipeline_descriptor.vertexDescriptor = vertex_descriptor

        do {
            self.pipelineState = try device.makeRenderPipelineState(descriptor: pipeline_descriptor)
        } catch {
            print("[ERROR] Pipeline creation failed:", error)
            return nil
        }

        let depthDescriptor = MTLDepthStencilDescriptor()
        depthDescriptor.depthCompareFunction = .less
        depthDescriptor.isDepthWriteEnabled = true
        guard let depthState = device.makeDepthStencilState(descriptor: depthDescriptor) else {
            print("[ERROR] Depth stencil state creation failed")
            return nil
        }
        self.depthStencilState = depthState

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
        enc.setDepthStencilState(depthStencilState)

        let viewMatrix = scene.GetViewMatrix()
        let aspect = worldController.aspect
        let projectionMatrix = simd_float4x4.perspective(
            fovRadians: degToRad(worldController.fov),
            aspectRatio: aspect,
            near: worldController.znear,
            far: worldController.zfar
        )
        
        for mesh in scene.meshes {
            let modelMatrix = mesh.getModelMatrix()
            let finalMVP = projectionMatrix * viewMatrix * modelMatrix

            let upperLeft = simd_float3x3(
                simd_make_float3(modelMatrix.columns.0),
                simd_make_float3(modelMatrix.columns.1),
                simd_make_float3(modelMatrix.columns.2)
            )
            let normalMatrix = upperLeft.inverse.transpose

            var uniforms = CGUniforms(mvp: finalMVP, lightPosition: worldController.lightPosition, lightColor: worldController.lightColor, modelMatrix: modelMatrix, normalMatrix: normalMatrix)
            
            
            
            enc.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
            
            
            
            enc.setVertexBytes(&uniforms, length: MemoryLayout<CGUniforms>.stride, index: 1)
            
            enc.setFragmentBytes(&uniforms, length: MemoryLayout<CGUniforms>.stride, index: 1)
            
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
