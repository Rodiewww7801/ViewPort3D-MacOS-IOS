//
//  Model.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 29.04.2023.
//

import MetalKit

class Model: Transformable {
    let mesh: MTKMesh
    let name: String
    var transform: Transform
    
    init(device: MTLDevice, name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: "obj") else {
            fatalError("The model does not found")
        }
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .modelDefaultLayout, bufferAllocator: allocator)
        
        if let mdlMesh = asset.childObjects(of: MDLMesh.self).first as? MDLMesh {
            do {
                self.mesh = try MTKMesh(mesh: mdlMesh, device: device)
            } catch {
                fatalError("\(error)")
            }
        } else {
            fatalError("coudnt init MDLMesh for model")
        }
        
        self.name = name
        self.transform = Transform()
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        encoder.setVertexBuffer(self.mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
        for submesh in mesh.submeshes {
            encoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset)
        }
    }
}
