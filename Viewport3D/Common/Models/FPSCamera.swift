//
//  FPSCamera.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 07.05.2023.
//

import Foundation

class FPSCamera: Camera {    
    var transform: Transform
    private var aspect: Float
    private var fov: Float
    private var near: Float
    private var far: Float
    
    var projectionMatrix: float4x4 {
        return float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        let rotationMatrix = float4x4(rotationYXZ: [-self.transform.rotation.x, self.transform.rotation.y, 0])
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
        self.transform.position += movement.position
        
        let input = InputController.shared
        
        transform.rotation.x += Float(input.mouseDelta.y) * Movement.Settings.mousePanSensitivity
        transform.rotation.y += Float(input.mouseDelta.x) * Movement.Settings.mousePanSensitivity
        transform.rotation.x = max(-.pi / 2, min(transform.rotation.x, .pi / 2))
        input.mouseDelta = .zero
        
    }
}

extension FPSCamera: Movable {
    
}
