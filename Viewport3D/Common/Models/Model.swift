//
//  Model.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 29.04.2023.
//

import MetalKit

class Model: Transformable {
    let name: String
    var transform: Transform
    var meshes: [Mesh] = []
    
    private var timer: Float = 0.0
    
    init(device: MTLDevice, name: String) {
        guard let assetURL = Bundle.main.url(forResource: name, withExtension: "obj") else {
            fatalError("The model does not found")
        }
        
        let allocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: .modelDefaultLayout, bufferAllocator: allocator)
        
        if let mdlMeshes = asset.childObjects(of: MDLMesh.self) as? [MDLMesh] {
            for mdlMesh in mdlMeshes {
                mdlMesh.addNormals(withAttributeNamed: MDLVertexAttributeNormal, creaseThreshold: 0.0)
                let mtkMesh = try? MTKMesh(mesh: mdlMesh, device: device)
                if let mtkMesh = mtkMesh {
                    let mesh = Mesh(mdlMesh: mdlMesh, mtkMesh: mtkMesh)
                    meshes.append(mesh)
                }
            }
        }
        
        self.name = name
        self.transform = Transform()
    }
}

// MARK: - Render

extension Model {    
    func render(encoder: MTLRenderCommandEncoder) {
        encoder.setTriangleFillMode(.fill)
        
        // render meshes
        for mesh in meshes {
            for (index, mtkMeshVertexBuffer) in mesh.mtkMesh.vertexBuffers.enumerated() {
                encoder.setVertexBuffer(mtkMeshVertexBuffer.buffer, offset: 0, index: index)
            }
            
            for submesh in mesh.submesh {
                encoder.setFragmentTexture(submesh.textures.baseColor, index: BaseColor.index)
                
                encoder.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: submesh.mtkSubmesh.indexCount,
                    indexType: submesh.mtkSubmesh.indexType,
                    indexBuffer: submesh.mtkSubmesh.indexBuffer.buffer,
                    indexBufferOffset: submesh.mtkSubmesh.indexBuffer.offset)
            }
        }
    }
    
}
