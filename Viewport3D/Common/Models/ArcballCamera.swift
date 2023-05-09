//
//  ArcballCamera.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 08.05.2023.
//

import Foundation

class ArcballCamera: Camera {
    var transform: Transform
    private var aspect: Float
    private var fov: Float
    private var near: Float
    private var far: Float
    private let minDistance: Float = 0.0
    private let maxDistance: Float = 20.0
    
    var target: float3 = [0,0,0]
    var distance: Float = 2.5
    
    var projectionMatrix: float4x4 {
        return float4x4(projectionFov: fov, near: near, far: far, aspect: aspect)
    }
    var viewMatrix: float4x4 {
        var viewMartix: float4x4
        if target == transform.position {
            viewMartix = (float4x4(translation: transform.position) * float4x4(rotationYXZ: transform.rotation)).inverse
        } else {
            viewMartix = float4x4(eye: transform.position, center: target, up: [0,1,0])
        }
        return viewMartix
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
        let input = InputController.shared
        distance += (Float(input.mouseScroll.x) + Float(input.mouseScroll.y)) * Movement.Settings.mouseScrollSensitivity
        distance = min(maxDistance, max(minDistance, distance))
        input.mouseScroll = .zero
        
        if input.leftMouseDown {
            transform.rotation.x += Float(input.mouseDelta.y) * Movement.Settings.mousePanSensitivity
            transform.rotation.y += Float(input.mouseDelta.x) * Movement.Settings.mousePanSensitivity
            transform.rotation.x = max(-.pi / 2, min(transform.rotation.x, .pi / 2))
            input.mouseDelta = .zero
        }
        
        let rotateMatrix = float4x4(rotationYXZ: [-transform.rotation.x, transform.rotation.y, 0])
        let distanceVector = float4(0, 0, -distance, 0)
        let rotatedVector = rotateMatrix * distanceVector
        transform.position = target + rotatedVector.xyz
        
    }
}
