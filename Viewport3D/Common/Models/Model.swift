//
//  Model.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 29.04.2023.
//

import MetalKit

class Model: Transformable {
    //let mesh: MTKMesh
    let name: String
    var transform: Transform
    
    //todo: Create separated model for meshes
    var mdlMeshes: [MDLMesh] = []
    var mtkMeshes: [MTKMesh] = []
    
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
                    self.mdlMeshes.append(mdlMesh)
                    self.mtkMeshes.append(mtkMesh)
                }
            }
        }
        
        self.name = name
        self.transform = Transform()
    }
}

// MARK: - Render

extension Model {
    
    func transformModel() {
        self.timer += 0.05
        let sinTimer = sin(timer)
        self.transform.position = [0,0,0]
        self.transform.rotation = [0, sinTimer + Float(-90).degreesToRadians , 0]
    }
    
    func render(encoder: MTLRenderCommandEncoder) {
        
        // render meshes
        for mtkMesh in mtkMeshes {
            for (index, mtkMeshVertexBuffer) in mtkMesh.vertexBuffers.enumerated() {
                encoder.setVertexBuffer(mtkMeshVertexBuffer.buffer, offset: 0, index: index)
            }
            
            for mtkSubmesh in mtkMesh.submeshes {
                encoder.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mtkSubmesh.indexCount,
                    indexType: mtkSubmesh.indexType,
                    indexBuffer: mtkSubmesh.indexBuffer.buffer,
                    indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }
    
}
