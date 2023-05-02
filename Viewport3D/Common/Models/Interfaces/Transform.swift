//
//  Transform.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

import Foundation

protocol Transformable {
    var transform: Transform {get set}
}

struct Transform {
    var position: float3 = [0,0,0]
    var rotation: float3 = [0,0,0]
    var scale: Float = 1
}

extension Transform {
    var modelMatrix: matrix_float4x4 {
        let positionMatrix = matrix_float4x4(translation: self.position)
        let rotationMatrix = matrix_float4x4(rotation: self.rotation)
        let scaleMatrix = matrix_float4x4(scaling: self.scale)
        let modelMatrix = positionMatrix * rotationMatrix * scaleMatrix
        return modelMatrix
    }
}
