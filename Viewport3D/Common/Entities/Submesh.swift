//
//  Submesh.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 02.05.2023.
//

import MetalKit

class Submesh {
    struct Textures {
        let baseColor: MTLTexture?
    }
    
    let textures: Textures
    let mdlSubmesh: MDLSubmesh?
    let mtkSubmesh: MTKSubmesh
    
    init(mdlSubmesh: MDLSubmesh?, mtkSubmesh: MTKSubmesh)  {
        self.mdlSubmesh = mdlSubmesh
        self.mtkSubmesh = mtkSubmesh
        self.textures = Textures(material: mdlSubmesh?.material)
    }
}


extension Submesh.Textures  {
    init(material: MDLMaterial?) {
        func property(with semantic: MDLMaterialSemantic) -> MTLTexture? {
            guard let property = material?.property(with: semantic),
                  property.type == .string,
                  let filename = property.stringValue,
                  let texture = TextureController.shared.getTexture(filename: filename)
            else {
                return nil
            }
            return texture
        }
        
        self.baseColor = property(with: MDLMaterialSemantic.baseColor)
    }
}
