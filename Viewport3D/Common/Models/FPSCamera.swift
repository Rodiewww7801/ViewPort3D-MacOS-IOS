//
//  FPSCamera.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 07.05.2023.
//

import Foundation

class FPSCamera: Camera {    
    var transform: Transform
    var aspect: Float
    var fov: Float
    var near: Float
    var far: Float
    
    var projectionMatrix: float4x4 {
        return float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        let rotationMatrix = float4x4(rotation: self.transform.rotation)
        let positionMatrix = float4x4(translation: self.transform.position)
        return (positionMatrix * rotationMatrix).inverse
    }
    
    init() {
        self.transform = Transform()
        self.aspect = 1.0
        self.fov = Float(70).degreesToRadians
        self.near = 0.1
        self.far = 100
    }
    
    func update(size: CGSize) {
        aspect = Float(size.width  / size.height)
    }
    
    func update(deltaTime: Float) {
        let movement = self.updateInput(deltaTime: deltaTime)
        self.transform.rotation += movement.rotation
    }
}

extension FPSCamera: Movable {
    
}
