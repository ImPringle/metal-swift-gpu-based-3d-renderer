//
//  RenderScene.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 19/07/26.
//

import simd
import CGMath

class RenderScene {
    var meshes: [Mesh] = []
    var isActive: Bool?
    
    private var worldController: WorldController
    var cameraRotation = simd_float4x4(1)
    
    init(worldController: WorldController) {
        self.worldController = worldController
    }
    
    func GetViewMatrix() -> simd_float4x4 {
        return simd_float4x4.translation(x: -worldController.cameraPosX, y: -worldController.cameraPosY, z: worldController.cameraPosZ) * cameraRotation
    }
}
