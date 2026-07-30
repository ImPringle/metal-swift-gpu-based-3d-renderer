//
//  Mesh.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 19/07/26.
//

import MetalKit
import simd

protocol Mesh {
    var vertexBuffer: MTLBuffer { get }
    var indexBuffer: MTLBuffer { get }
    var indexCount: Int { get }
    var modelMatrix: simd_float4x4 { get }
    var primitiveType: MTLPrimitiveType { get }
    
    func getModelMatrix() -> simd_float4x4
}
