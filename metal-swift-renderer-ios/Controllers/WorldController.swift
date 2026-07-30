//
//  WorldController.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 18/07/26.
//

import Foundation
import Combine

class WorldController: ObservableObject {
    @Published var aspect: Float = 0.0
    
    @Published var fov: Float = 65.0
    @Published var fovRange: ClosedRange<Float> = 45.0...120.0
    
    @Published var znear: Float = 0.1
    @Published var znearRange: ClosedRange<Float> = 0.1...99.9
    
    @Published var zfar: Float = 100.0
    @Published var zfarRange: ClosedRange<Float> = 0.1...100.0
    
    @Published var cameraPosX: Float = 0
    @Published var cameraPosY: Float = 0
    @Published var cameraPosZ: Float = 0
    
}
