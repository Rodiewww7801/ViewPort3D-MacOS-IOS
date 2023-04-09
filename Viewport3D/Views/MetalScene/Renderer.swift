//
//  Renderer.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import Foundation
import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    static private(set) var device: MTLDevice!
    static private(set) var commandQueue: MTLCommandQueue!
    static private(set) var library: MTLLibrary!
    private var mesh: MTKMesh!
    private var vertexBuffer: MTLBuffer!
    private var pipelineDescriptor: MTLRenderPipelineDescriptor!
    private var pipelineState: MTLRenderPipelineState!
    private let metalView: MTKView
    
    init(metalView: MTKView) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
                fatalError("Coud not support Metal")
            }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        self.metalView = metalView
        
        super.init()
        
        metalView.device = Renderer.device
        metalView.delegate = self
        metalView.clearColor = MTLClearColorMake(1, 0, 1, 1)
        
        createLibrary()
        createPipelineDescriptor()
        createCubeMesh()
        createPipelineState()
    }
    
    private func createCubeMesh() {
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let size: Float = 0.8
        let mdlMesh = MDLMesh(boxWithExtent: [size, size, size],
                              segments: [1,1,1],
                              inwardNormals: false,
                              geometryType: .triangles,
                              allocator: allocator)
        
        do {
            self.mesh = try MTKMesh(mesh: mdlMesh, device: Renderer.device)
        } catch {
            fatalError("cant initilize MTKMesh")
        }
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        //set vertex descriptor of model
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(mdlMesh.vertexDescriptor)
    }
    
    private func createLibrary() {
        //create library
        let library = Renderer.device.makeDefaultLibrary()
        Renderer.library = library
    }
    
    private func createPipelineDescriptor() {
        let vertexFunction = Renderer.library.makeFunction(name: "vertex_main")
        let fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        
        //create pipeline descriptor
        self.pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
    }
    
    private func createPipelineState() {
        //create pipeline state
        do {
            self.pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("\(error)")
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("drawableSizeWillChange")
    }
    
    func draw(in view: MTKView) {
        guard
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let currentRednderPassDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: currentRednderPassDescriptor)
        else {
            print("Coudn't render view")
            return
        }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.setTriangleFillMode(.lines)
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            print("Coudn't render view")
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
