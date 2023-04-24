//
//  Circle.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 19.04.2023.
//

import Foundation
import MetalKit

class Sphere: Primitive {

    private let radius: Float
    private let scale: Float
    private let poligons: Int
    
    public var circleVertices: [simd_float3] = []
    public var indices: [UInt16] = []
    public var verticesBuffer: MTLBuffer
    public var indicesBuffer: MTLBuffer
    
    init(device: MTLDevice, radius: Float = 1, scale: Float = 1.0, poligons: Int = 50) {
        self.radius = radius
        self.scale = scale
        self.poligons = poligons
        self.circleVertices = Sphere.initCircleVertices(radius: radius, poligons: poligons).map({ $0 * scale })
        self.indices = Sphere.getPathIndices(circleVertices: self.circleVertices)
        
        guard let circleVerticesBuffer = device.makeBuffer(
            bytes: &circleVertices,
            length: MemoryLayout<simd_float3>.stride * circleVertices.count,
            options: []) else {
            fatalError("coudnt create sphere")
        }
        self.verticesBuffer = circleVerticesBuffer
        
        guard let indicesBuffer = device.makeBuffer(
            bytes: &indices,
            length: MemoryLayout<UInt16>.stride * indices.count,
            options: []) else {
            fatalError("coudnt create sphere")
        }
        self.indicesBuffer = indicesBuffer
    }
    
    private class func getPathIndices(circleVertices: [simd_float3]) -> [UInt16] {
        var sphereVertices: [simd_float3] = []
        var currentPosition: simd_float3
        var indexPath: [UInt16] = []
        var i16: UInt16 = 1
        
        indexPath.append(0)
        
        for i in 1..<circleVertices.count {
            currentPosition = circleVertices[i]
            sphereVertices.append(currentPosition)
            indexPath.append(i16)
           
            if i != 1 {
                sphereVertices.append(circleVertices[0])
                indexPath.append(0)
                sphereVertices.append(currentPosition)
                indexPath.append(i16)
            }
            
            i16 += 1
        }
        
        return indexPath
    }
    
    private class func initCircleVertices(radius: Float, poligons: Int) -> [simd_float3] {
        var circleVertices: [simd_float3] = []
        
        let centerPosition = simd_float3(0,0,0)
        circleVertices.append(centerPosition)
        
        for i in 0...poligons {
            var positionXY: simd_float2 = simd_float2()
            let alpha: Float = ((2 * Float.pi) / Float(poligons) ) * Float(i)
            positionXY.x = radius * cos(alpha)
            positionXY.y = radius * sin(alpha)
            
            circleVertices.append(simd_float3(positionXY, 0))
        }
        
        return circleVertices
    }
}
