//
//  Grid.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 18/07/26.
//

import Foundation
import CGMath
import MetalKit
import simd

struct Grid: Mesh {
    let device: MTLDevice
    let vertices: [CGVertex]
    let indices: [UInt16]
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    let indexCount: Int
    var modelMatrix: simd_float4x4 = simd_float4x4(1)
    let primitiveType: MTLPrimitiveType = .line

    init(device: MTLDevice, divisions: Int = 20, spacing: Float = 1,
         color: SIMD4<Float> = SIMD4<Float>(0.6, 0.6, 0.6, 1.0)) {
        self.device = device
        let half = Float(divisions) * spacing / 2
        var verts: [CGVertex] = []
        var idx: [UInt16] = []

        verts.reserveCapacity((divisions + 1) * 4)
        idx.reserveCapacity((divisions + 1) * 4)

        for i in 0...divisions {
            let offset = Float(i) * spacing - half

            // Line parallel to the Z axis.
            verts.append(CGVertex(position: SIMD4<Float>(offset, 0, -half, 1.0), color: color))
            idx.append(UInt16(i * 4))
            verts.append(CGVertex(position: SIMD4<Float>(offset, 0, half, 1.0), color: color))
            idx.append(UInt16(i * 4 + 1))

            // Line parallel to the X axis.
            verts.append(CGVertex(position: SIMD4<Float>(-half, 0, offset, 1.0), color: color))
            idx.append(UInt16(i * 4 + 2))
            verts.append(CGVertex(position: SIMD4<Float>(half, 0, offset, 1.0), color: color))
            idx.append(UInt16(i * 4 + 3))
        }

        vertices = verts
        indices = idx

        self.vertexBuffer = Grid.makeVertexBuffer(device: device, vertices: verts)
        self.indexBuffer = Grid.makeIndexBuffer(device: device, indices: idx)
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
    
    public func getModelMatrix() -> simd_float4x4 {
        return modelMatrix
    }
}
