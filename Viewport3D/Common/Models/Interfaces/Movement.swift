//
//  Movement.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 07.05.2023.
//

import Foundation

protocol Movable where Self: Transformable {
    
}

extension Movable {
    
    var forwardVector: float3 {
        return normalize([sin(self.transform.rotation.y), 0, cos(self.transform.rotation.y)])
    }
    
    var rightVector: float3 {
        return [forwardVector.z, 0, -forwardVector.x]
    }
    
    func updateInput(deltaTime: Float) -> Transform {
        var transform = Transform()
        let rotationAmount = deltaTime * Movement.Settings.rotationSpeed
        let translationAmount = deltaTime * Movement.Settings.translationSpeed
        let input = InputController.shared.keyPressed
        var direction: float3 = float3()
        
        if input.contains(.leftArrow) {
            transform.rotation.y -= rotationAmount
        }
        
        if input.contains(.rightArrow) {
            transform.rotation.y += rotationAmount
        }
        
        if input.contains(.downArrow) {
            transform.rotation.x -= rotationAmount
        }
        
        if input.contains(.upArrow) {
            transform.rotation.x += rotationAmount
        }
        
        if input.contains(.keyW) {
            direction.z += 1
        }
        
        if input.contains(.keyS) {
            direction.z -= 1
        }
        
        if input.contains(.keyA) {
            direction.x -= 1
        }
        
        if input.contains(.keyD) {
            direction.x += 1
        }
        
        if direction != .zero {
            direction = normalize(direction)
            transform.position += (direction.z * forwardVector + direction.x * rightVector) * translationAmount
        }
        
        return transform
    }
}

class Movement {
    enum Settings {
        
        static var rotationSpeed: Float {
            return 2.0
        }
        
        static var translationSpeed: Float {
            return 3.0
        }
        
        static var mouseScrollSensitivity: Float {
            return 0.1
        }
        
        static var mousePanSensitivity: Float {
            return 0.005
        }
    }
}
