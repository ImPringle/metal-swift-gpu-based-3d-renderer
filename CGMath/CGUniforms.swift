//
//  CGUniforms.swift
//  CGMath
//
//  Created by Mario Zuniga on 19/07/26.
//

import simd

public struct CGUniforms {
    var mvp: simd_float4x4
    var lightPosition: simd_float3
    var lightColor: simd_float4
    var modelMatrix: simd_float4x4
    var normalMatrix: simd_float3x3
    
    public init(mvp: simd_float4x4, lightPosition: simd_float3, lightColor: simd_float4, modelMatrix: simd_float4x4, normalMatrix: simd_float3x3) {
        self.mvp = mvp
        self.lightPosition = lightPosition
        self.lightColor = lightColor
        self.modelMatrix = modelMatrix
        self.normalMatrix = normalMatrix
    }
}
