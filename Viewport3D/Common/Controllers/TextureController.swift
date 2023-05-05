//
//  TextureController.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 02.05.2023.
//

import MetalKit

class TextureController {
    static var shared: TextureController = TextureController()
    
    var textures: [String:MTLTexture] = [:]
    
    func loadTextures(filename: String) throws -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let textureLoaderOptions: [MTKTextureLoader.Option : Any] = [
            .origin: MTKTextureLoader.Origin.bottomLeft,
            .SRGB : false,
            .generateMipmaps: NSNumber(value: true)
        ]
        let fileExtension = URL(fileURLWithPath: filename).pathExtension.isEmpty ? "png" : nil
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            print("[TextureController]: Failed to load \(filename)")
            return nil
        }
        
        let texture = try textureLoader.newTexture(URL: url, options: textureLoaderOptions)
        print("[TextureController]: Loaded texture: \(url.lastPathComponent)")
        return texture
    }
    
    func getTexture(filename: String) -> MTLTexture? {
        if let texture = textures[filename] {
            return texture
        }
        
        if let texture = try? loadTextures(filename: filename) {
            textures[filename] = texture
            return texture
        }
        
        return nil
    }
}
