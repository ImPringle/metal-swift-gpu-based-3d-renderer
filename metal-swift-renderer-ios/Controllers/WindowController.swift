//
//  WindowController.swift
//  metal-swift-renderer-ios
//
//  Created by Mario Zuniga on 22/07/26.
//

import Foundation

import Combine
import MetalKit

class WindowController: ObservableObject {
    @Published var windowBounds: CGRect = CGRect()
}
