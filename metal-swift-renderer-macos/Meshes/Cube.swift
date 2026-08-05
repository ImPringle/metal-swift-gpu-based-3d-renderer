//
//  Cube.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 21/07/26.
//

import Foundation
import CGMath
import MetalKit
import simd

struct Cube: Mesh {
    func getModelMatrix() -> simd_float4x4 {
        return simd_float4x4.translation(x: at.x, y: at.y, z: at.z)
    }
    let device: MTLDevice
    let vertices: [CGVertex]
    let indices: [UInt16]
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let indexCount: Int
    let primitiveType: MTLPrimitiveType = .triangle
    var modelMatrix: simd_float4x4 = simd_float4x4(1)
    var at: SIMD3<Float> = SIMD3()
    var color: SIMD4<Float> = SIMD4()
    
    init(device: MTLDevice,
         color: SIMD4<Float> = SIMD4<Float>(0.0, 0.8, 0.8, 1.0),
         at: SIMD3<Float> = SIMD3<Float>(0,0,0)
    ) {
        self.device = device
        
        self.at = at
        self.color = color

        // Cube spanning (0,0,0) front-bottom-left to (1,1,1) back-top-right.
        // z = 0 is the front face, z = 1 is the back face.
        let points: [SIMD4<Float>] = [
            // back face
            SIMD4<Float>(0, 0, 0, 1),
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(1, 1, 0, 1),
            SIMD4<Float>(1, 0, 0, 1),
            // front face
            SIMD4<Float>(0, 0, 1, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 0, 1, 1),
            // left face
            SIMD4<Float>(0, 0, 0, 1),
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(0, 0, 1, 1),
            // right face
            SIMD4<Float>(1, 0, 1, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 1, 0, 1),
            SIMD4<Float>(1, 0, 0, 1),
            // top face
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 1, 0, 1),
            // bottom face
            SIMD4<Float>(0, 0, 0, 1),
            SIMD4<Float>(0, 0, 1, 1),
            SIMD4<Float>(1, 0, 1, 1),
            SIMD4<Float>(1, 0, 0, 1)
        ]
        
        let normals: [SIMD3<Float>] = [
            // back face
            SIMD3<Float>(0, 0, 1),
            SIMD3<Float>(0, 0, 1),
            SIMD3<Float>(0, 0, 1),
            SIMD3<Float>(0, 0, 1),
            // front face
            SIMD3<Float>(0, 0, -1),
            SIMD3<Float>(0, 0, -1),
            SIMD3<Float>(0, 0, -1),
            SIMD3<Float>(0, 0, -1),
            // left face
            SIMD3<Float>(-1, 0, 0),
            SIMD3<Float>(-1, 0, 0),
            SIMD3<Float>(-1, 0, 0),
            SIMD3<Float>(-1, 0, 0),
            // right face
            SIMD3<Float>(1, 0, 0),
            SIMD3<Float>(1, 0, 0),
            SIMD3<Float>(1, 0, 0),
            SIMD3<Float>(1, 0, 0),
            // top face
            SIMD3<Float>(0, 1, 0),
            SIMD3<Float>(0, 1, 0),
            SIMD3<Float>(0, 1, 0),
            SIMD3<Float>(0, 1, 0),
            // bottom face
            SIMD3<Float>(0, -1, 0),
            SIMD3<Float>(0, -1, 0),
            SIMD3<Float>(0, -1, 0),
            SIMD3<Float>(0, -1, 0)
        ]
        
        var verts: [CGVertex] = []
        for (idx, point) in points.enumerated() {
            verts.append(CGVertex(position: point, normal: normals[idx], color: color))
        }

        let idx: [UInt16] = [
            // front face
            0, 1, 2,
            0, 2, 3,
            // back face
            4, 5, 6,
            4, 6, 7,
            // left face
            8, 9, 10,
            8, 10, 11,
            // right face
            12, 13, 14,
            12, 14, 15,
            // top face
            16, 17, 18,
            16, 18, 19,
            // bottom face
            20, 21, 22,
            20, 22, 23
        ]

        vertices = verts
        indices = idx

        self.vertexBuffer = Cube.makeVertexBuffer(device: device, vertices: verts)
        self.indexBuffer = Cube.makeIndexBuffer(device: device, indices: idx)
        self.indexCount = idx.count
    }

    private static func makeVertexBuffer(device: MTLDevice, vertices: [CGVertex]) -> MTLBuffer {
        return vertices.withUnsafeBytes { bufferPointer in
            guard let baseAddress = bufferPointer.baseAddress else {
                fatalError("Vertex arrat is empty or invalid")
            }
            return device.makeBuffer(bytes: baseAddress,
                                     length: vertices.count * MemoryLayout<CGVertex>.stride,
                                     options: [])!
        }
    }

    private static func makeIndexBuffer(device: MTLDevice, indices: [UInt16]) -> MTLBuffer {
        device.makeBuffer(bytes: indices,
                          length: indices.count * MemoryLayout<UInt16>.stride,
                          options: [])!
    }
}
