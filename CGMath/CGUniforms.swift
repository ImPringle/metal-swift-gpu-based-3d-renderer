//
//  CGUniforms.swift
//  CGMath
//
//  Created by Mario Zuniga on 19/07/26.
//

import simd

public struct CGUniforms {
    var mvp: simd_float4x4
    
    public init(mvp: simd_float4x4) {
        self.mvp = mvp
    }
}
