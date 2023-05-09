//
//  OrthographicCamera.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 08.05.2023.
//

import Foundation

class OrthographicCamera: Camera, Movable {
    var transform: Transform
    var aspect: CGFloat = 1
    var viewSize: CGFloat = 2
    var near: Float = 0.1
    var far: Float = 100
    
    var projectionMatrix: float4x4 {
        let rect = CGRect(x: -viewSize * aspect * 0.5,
                          y: viewSize * 0.5,
                          width: viewSize * aspect,
                          height: viewSize)
        return float4x4(orthographic: rect, near: near, far: far)
    }
    
    var viewMatrix: float4x4 {
        let translationMatrix = float4x4(translation: self.transform.position)
        let rotationMatrix = float4x4(rotation: self.transform.rotation)
        return (rotationMatrix * translationMatrix).inverse
    }
    
    init() {
        self.transform = Transform()
    }
    
    func update(size: CGSize) {
        self.aspect = size.width / size.height
    }
    
    func update(deltaTime: Float) {
        let transform = updateInput(deltaTime: deltaTime)
        self.transform.position += transform.position
        let input = InputController.shared
        let zoom = input.mouseScroll.x + input.mouseScroll.y
        self.viewSize -= CGFloat(zoom)
        input.mouseScroll = .zero
    }
}
