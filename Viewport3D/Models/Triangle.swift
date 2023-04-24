//
//  Triangle.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 24.04.2023.
//

import Foundation
import MetalKit

class Triangle: Primitive {
    var verticesBuffer: MTLBuffer
    var indicesBuffer: MTLBuffer
    
    init(device: MTLDevice, scale: Float = 1.0) {
        self.vertices = self.vertices.map { $0 * scale }
        guard let verticesBuffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<simd_float3>.stride * vertices.count,
            options: []) else {
            fatalError("coudnt create triangle")
        }
        self.verticesBuffer = verticesBuffer
        
        guard let indicesBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []) else {
            fatalError("coudnt create triangle")
        }
        self.indicesBuffer = indicesBuffer
    }
    
    var vertices: [simd_float3] =  [
        [-1,1,0],
        [1,0,0],
        [-1,-1,0]
    ]
    
    var indices: [UInt16] = [
        0,1,2
    ]
}
