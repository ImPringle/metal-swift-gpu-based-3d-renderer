//
//  WorldController.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 18/07/26.
//

import Foundation
import Combine
import MetalKit

class WorldController: ObservableObject {
    @Published var aspect: Float = 0.0
    
    @Published var fov: Float = 65.0
    @Published var fovRange: ClosedRange<Float> = 45.0...120.0
    
    @Published var znear: Float = 0.1
    @Published var znearRange: ClosedRange<Float> = 0.1...999.9
    
    @Published var zfar: Float = 100.0
    @Published var zfarRange: ClosedRange<Float> = 0.1...1000.0
    
    @Published var cameraPosX: Float = 0
    @Published var cameraPosY: Float = 10
    @Published var cameraPosZ: Float = -20
    
    @Published var lightPosition: SIMD3<Float> = SIMD3<Float>(0, 0, 0)
    @Published var lightColor: SIMD4<Float> = SIMD4<Float>(1, 1, 1, 1)

    @Published var lightPositionRange: ClosedRange<Float> = -300.0...300.0
    
    
    public func generateRandomCubes(device: MTLDevice, _ amount: Int, _ range: Int) -> [Cube] {
        var cubes: [Cube] = []
        
        var colorRange: ClosedRange<Float> = 0...1.0
        var positionRange: ClosedRange<Int> = -range...range
        
        for _ in 0...amount {
            let randomColor: SIMD4<Float> = SIMD4<Float>(
                Float.random(in: colorRange),
                Float.random(in: colorRange),
                Float.random(in: colorRange),
                1
            )
            let randomPosition: SIMD3<Float> = SIMD3<Float>(
                Float(Int.random(in: positionRange)),
                Float(Int.random(in: positionRange)),
                Float(Int.random(in: positionRange))
            )
            
            let cube: Cube = Cube(device: device, color: randomColor, at: randomPosition)
            cubes.append(cube)
        }
        
        return cubes
    }
    
}
