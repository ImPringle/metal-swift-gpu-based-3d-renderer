//
//  CGSimd.swift
//  CGMath
//
//  Created by Mario Zuniga on 19/07/26.
//

import simd

extension simd_float4x4 {
    public static var identity: simd_float4x4 {
        return simd_float4x4(1)
    }
    
    public static func translation(x: Float, y: Float, z: Float) -> simd_float4x4 {
        return simd_float4x4(
            SIMD4<Float>(1, 0, 0, 0),
            SIMD4<Float>(0, 1, 0, 0),
            SIMD4<Float>(0, 0, 1, 0),
            SIMD4<Float>(x, y, z, 1)
        )
    }
    
    public static func perspective(fovRadians: Float, aspectRatio: Float, near: Float, far: Float) -> simd_float4x4 {
        let ys = 1 / tan(fovRadians * 0.5)
        let xs = ys / aspectRatio
        let zs = far / (near - far)
        
        return simd_float4x4(
            SIMD4<Float>(xs, 0, 0, 0),
            SIMD4<Float>(0, ys, 0, 0),
            SIMD4<Float>(0, 0, zs, -1),
            SIMD4<Float>(0, 0, zs * near, 0)
        )
    }
}


