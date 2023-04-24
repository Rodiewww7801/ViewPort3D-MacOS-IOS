//
//  Quad.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 12.04.2023.
//

import Foundation
import MetalKit

class Quad: Primitive {
    var verticesBuffer: MTLBuffer
    var indicesBuffer: MTLBuffer
    
    let colorBuffer: MTLBuffer
    
    
    init(device: MTLDevice, scale: Float = 1.0) {
        self.vertices = vertices.map { $0 * scale }
        guard let vertexBuffer = device.makeBuffer(
            bytes: &vertices,
            length: MemoryLayout<Float>.stride * vertices.count,
            options: [])
        else {
            fatalError("Unable to create quad vertex buffer")
        }
        self.verticesBuffer = vertexBuffer
        
        guard let indexBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []) else {
            fatalError("Unable to create quad index buffer")
        }
        self.indicesBuffer = indexBuffer
        
        guard let colorsBuffer = device.makeBuffer(
            bytes: &colors,
            length: MemoryLayout<simd_float3>.stride * colors.count,
            options: []) else {
            fatalError("Unable to create quad colors buffer")
        }
        self.colorBuffer = colorsBuffer
    }
    
    var oldVertices: [Float] = [
        -1, 1,  0,
         1, 1,  0,
         1, -1, 0,
         -1, 1,  0,
         -1, -1, 0,
         1, -1, 0
    ]
    
    var vertices: [Float] = [
        -1, 1, 0,
         1, 1, 0,
         -1, -1, 0,
         1, -1, 0
    ]
    
    var indices: [UInt16] = [
        0, 3, 2,
        0, 1, 3
    ]
    
    var colors: [simd_float3] =
    [[1, 0, 0],
     [0, 1, 0],
     [0, 0, 1],
     [1, 1, 1]
    ]
    
}
