//
//  Camera.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 07.05.2023.
//

import Foundation

protocol Camera: Transformable {
    var projectionMatrix: float4x4 { get }
    var viewMatrix: float4x4 { get }
    
    func update(size: CGSize)
    func update(deltaTime: Float)
}
