//
//  Primitives.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 24.04.2023.
//

import Foundation
import Metal

protocol Primitive {
    var verticesBuffer: MTLBuffer {get set}
    var indicesBuffer: MTLBuffer {get set}
    var indices: [UInt16] {get set}
}
