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
        return modelMatrix
    }
    let device: MTLDevice
    let vertices: [CGVertex]
    let indices: [UInt16]
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let indexCount: Int
    let primitiveType: MTLPrimitiveType = .triangle
    var modelMatrix: simd_float4x4 = simd_float4x4(1)
    
    init(device: MTLDevice,
         color: SIMD4<Float> = SIMD4<Float>(0.0, 0.8, 0.8, 1.0),
         at: SIMD3<Float> = SIMD3<Float>(0,0,0)
    ) {
        self.device = device

        // Cube spanning (0,0,0) front-bottom-left to (1,1,1) back-top-right.
        // z = 0 is the front face, z = 1 is the back face.
        let corners: [SIMD4<Float>] = [
            // front face
            SIMD4<Float>(0, 0, 0, 1),
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(1, 1, 0, 1),
            SIMD4<Float>(1, 0, 0, 1),
            // back face
            SIMD4<Float>(0, 0, 1, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 0, 1, 1),
            // left face
            SIMD4<Float>(0, 0, 1, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(0, 0, 0, 1),
            // right face
            SIMD4<Float>(1, 0, 0, 1),
            SIMD4<Float>(1, 1, 0, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 0, 1, 1),
            // top face
            SIMD4<Float>(0, 1, 0, 1),
            SIMD4<Float>(0, 1, 1, 1),
            SIMD4<Float>(1, 1, 1, 1),
            SIMD4<Float>(1, 1, 0, 1),
            // bottom face
            SIMD4<Float>(0, 0, 0, 1),
            SIMD4<Float>(0, 0, 1, 1),
            SIMD4<Float>(1, 0, 1, 1),
            SIMD4<Float>(1, 0, 0, 1),
        ]
        

        let verts = corners.map { CGVertex(position: $0, color: color) }

        // Two triangles per face, wound counter-clockwise when viewed from
        // outside the cube.
        let idx: [UInt16] = [
            // Front (z = 0)
            0, 2, 1,  0, 3, 2,
            // Back (z = 1)
            4, 5, 6,  4, 6, 7,
            // Left (x = 0)
            4, 3, 0,  4, 7, 3,
            // Right (x = 1)
            1, 2, 6,  1, 6, 5,
            // Bottom (y = 0)
            0, 1, 5,  0, 5, 4,
            // Top (y = 1)
            3, 7, 6,  3, 6, 2,
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
