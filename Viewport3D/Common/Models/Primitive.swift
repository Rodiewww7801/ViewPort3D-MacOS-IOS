//
//  Primitive.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 24.04.2023.
//

import Foundation
import MetalKit

protocol Primitive {
    var verticesBuffer: MTLBuffer {get set}
    var indicesBuffer: MTLBuffer {get set}
    var indices: [UInt16] {get set}
}

extension Primitive {
    func renderPrimitive(encoder: MTLRenderCommandEncoder) {
        encoder.setTriangleFillMode(.fill)
        
        let primitive = self
        
        encoder.setVertexBuffer(primitive.verticesBuffer, offset: 0, index: VertexBuffer.index)
        
        //original primitive
        var translation = matrix_float4x4()
        translation.columns.0 = [1,0,0,0]
        translation.columns.1 = [0,1,0,0]
        translation.columns.2 = [0,0,1,0]
        translation.columns.3 = [0, 0, 0, 1]
        
        encoder.setVertexBytes(&translation, length: MemoryLayout<matrix_float4x4>.stride, index: UniformsBuffer.index)
        
        var color_1 = simd_float4(0.9,0.9,0.9,1)
        encoder.setFragmentBytes(&color_1, length: MemoryLayout<simd_float4>.stride, index: 0)
        
        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: primitive.indices.count,
            indexType: .uint16,
            indexBuffer: primitive.indicesBuffer,
            indexBufferOffset: 0)
        
        //second primitive
        var matrix = matrix_float4x4()
        translation.columns.3 = [0.33, -0.33, 0, 1]
        translation.columns.3 = [0.5, 0, 0, 1]
        
        let angle = Float.pi / 2.0
        let rotationMatrix = float4x4(
            [cos(angle), -sin(angle), 0, 0],
            [sin(angle), cos(angle), 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1])
        
        matrix = translation * rotationMatrix * translation.inverse
        
        encoder.setVertexBytes(&matrix, length: MemoryLayout<matrix_float4x4>.stride, index: UniformsBuffer.index)
        
        color_1 = simd_float4(0,0,1,1)
        encoder.setFragmentBytes(&color_1, length: MemoryLayout<simd_float4>.stride, index: RenderParametersBuffer.index)
        
        encoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: primitive.indices.count,
            indexType: .uint16,
            indexBuffer: primitive.indicesBuffer,
            indexBufferOffset: 0)
    }
}
