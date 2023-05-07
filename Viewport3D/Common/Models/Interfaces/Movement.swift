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
    func updateInput(deltaTime: Float) -> Transform {
        var transform = Transform()
        let rotationAmount = deltaTime * Movement.Settings.rotationSpeed
        let input = InputController.shared.keyPressed
        
        if input.contains(.leftArrow) {
            transform.rotation.y -= rotationAmount
        }
        
        if input.contains(.rightArrow) {
            transform.rotation.y += rotationAmount
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
            return 0.08
        }
    }
}
