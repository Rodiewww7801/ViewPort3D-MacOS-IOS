//
//  Mesh.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 02.05.2023.
//

import MetalKit

class Mesh {
    let mdlMesh: MDLMesh
    let mtkMesh: MTKMesh
    var submesh: [Submesh] = []
    
    init(mdlMesh: MDLMesh, mtkMesh: MTKMesh) {
        self.mdlMesh = mdlMesh
        self.mtkMesh = mtkMesh
        
        for (mtkSubmesh, mdlSubmesh) in zip(mtkMesh.submeshes, mdlMesh.submeshes as? [MDLSubmesh] ?? []) {
            submesh.append(Submesh(mdlSubmesh: mdlSubmesh, mtkSubmesh: mtkSubmesh))
        }
        
    }
}
