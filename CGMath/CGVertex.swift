//
//  CGVertex.swift
//  CGMath
//
//  Created by Mario Zuniga on 18/07/26.
//

public struct CGVertex {
    public var position: SIMD4<Float>
    public var normal: SIMD3<Float>
    public var color: SIMD4<Float>

    public init(position: SIMD4<Float>, normal: SIMD3<Float>, color: SIMD4<Float>) {
        self.position = position
        self.normal = normal
        self.color = color
    }
}
