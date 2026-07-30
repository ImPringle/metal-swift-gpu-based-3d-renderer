//
//  WindowController.swift
//  metal-swift-renderer
//
//  Created by Mario Zuniga on 19/07/26.
//

import Combine
import MetalKit

class WindowController: ObservableObject {
    @Published var windowBounds: NSRect = NSRect()
}
