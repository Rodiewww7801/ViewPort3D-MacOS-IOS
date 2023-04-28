//
//  Renderer.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    static private(set) var device: MTLDevice!
    static private(set) var commandQueue: MTLCommandQueue!
    static private(set) var library: MTLLibrary!
    private var mesh: MTKMesh!
    private var vertexBuffers: [MTLBuffer] = []
    private var pipelineDescriptor: MTLRenderPipelineDescriptor!
    private var pipelineState: MTLRenderPipelineState!
    private let metalView: MTKView
    private let resourceName: String = "SVS61UZAH4OIDVNG1PSGCOM2D"
    private var timer: Float = 0.0
    private var primitive: Primitive?
    
    
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
        metalView.clearColor = MTLClearColorMake(255, 255, 255, 1)
        
        //renderModelLogicSetup()
        //renderQuadLogicSetup()
        renderTriangleLogic()
    }
    
    private func renderTriangleLogic() {
        createLibrary()
        createPipelineDescriptor()
        createTriangle()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.sphereDefaultLayout
        createPipelineState()
    }
    
    private func renderSphereLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createSphere()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.sphereDefaultLayout
        createPipelineState()
    }
    
    private func renderQuadLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createQuad()
        pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.cubeDefaultLayout
        createPipelineState()
    }
    
    private func renderModelLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        importObj()
        createPipelineState()
    }
    
    private func createSphere() {
        let sphere = Sphere(device: Renderer.device, scale: 0.4)
        self.primitive = sphere
    }
    
    private func createTriangle() {
        let triangle = Triangle(device: Renderer.device, scale: 0.5)
        self.primitive = triangle
    }
    
    private func createQuad() {
        let quad = Quad(device: Renderer.device, scale: 0.5)
        vertexBuffers.append(quad.verticesBuffer)
        vertexBuffers.append(quad.indicesBuffer)
        vertexBuffers.append(quad.colorBuffer)
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
        
        vertexBuffers[0] = mesh.vertexBuffers[0].buffer
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
    
    private func importObj() {
        guard let assetURL = Bundle.main.url(forResource: resourceName, withExtension: "obj") else {
            fatalError("Cant find resource \(resourceName).obj")
        }
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        
        vertexDescriptor.attributes[1].format = .float3
        vertexDescriptor.attributes[1].offset = 0
        vertexDescriptor.attributes[1].bufferIndex = 1
        vertexDescriptor.layouts[1].stride = MemoryLayout<SIMD3<Float>>.stride
        
        let meshDescriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        (meshDescriptor.attributes[0] as? MDLVertexAttribute)?.name = MDLVertexAttributePosition
        
        let allocator = MTKMeshBufferAllocator(device: Renderer.device)
        let asset = MDLAsset(url: assetURL,
                               vertexDescriptor: meshDescriptor,
                               bufferAllocator: allocator)
        
        if let mdlMesh = asset.childObjects(of: MDLMesh.self).first as? MDLMesh {
            self.mesh = try? MTKMesh(mesh: mdlMesh, device: Renderer.device)
        }
        
        vertexBuffers[0] = self.mesh.vertexBuffers[0].buffer
        pipelineDescriptor.vertexDescriptor = MTKMetalVertexDescriptorFromModelIO(meshDescriptor)
    }
}

extension Renderer: MTKViewDelegate {
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
        
        //renderObjectModel(renderEncoder: renderEncoder)
        setupTimer(renderEncoder: renderEncoder)
        //renderCircle(renderEncoder: renderEncoder)
        //renderQuad(renderEncoder: renderEncoder)
        renderSphere(renderEncoder: renderEncoder)
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            print("Coudn't render view")
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    private func setupTimer(renderEncoder: MTLRenderCommandEncoder) {
        timer += 0.05
        var currentTime = sin(timer)
        renderEncoder.setVertexBytes(
            &currentTime,
            length: MemoryLayout<Float>.stride,
            index: 11)
    }
    
    private func renderCircle(renderEncoder: MTLRenderCommandEncoder) {
        var countOfPointsInCircle = 50
        renderEncoder.setVertexBytes(&countOfPointsInCircle, length: MemoryLayout<Int>.stride, index: 0)
        renderEncoder.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: 51)
    }
    
    private func renderSphere(renderEncoder: MTLRenderCommandEncoder) {
        guard let sphere = primitive else { return }
        
        renderEncoder.setVertexBuffer(sphere.verticesBuffer, offset: 0, index: 0)
        
        //original sphere
        var translation = matrix_float4x4()
        translation.columns.0 = [1,0,0,0]
        translation.columns.1 = [0,1,0,0]
        translation.columns.2 = [0,0,1,0]
        translation.columns.3 = [0, 0, 0, 1]
        renderEncoder.setVertexBytes(&translation, length: MemoryLayout<matrix_float4x4>.stride, index: 12)
        var color_1 = simd_float4(0.9,0.9,0.9,1)
        renderEncoder.setFragmentBytes(&color_1, length: MemoryLayout<simd_float4>.stride, index: 0)
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: sphere.indices.count,
            indexType: .uint16,
            indexBuffer: sphere.indicesBuffer,
            indexBufferOffset: 0)
        
        //second sphere
      
        var matrix = matrix_float4x4()
        
        translation.columns.3 = [0.33, -0.33, 0, 1]
        translation.columns.3 = [0.5, 0, 0, 1]
        
        let angle = Float.pi / 2.0
        let rotationMatrix = float4x4(
            [cos(angle), -sin(angle), 0, 0],
            [sin(angle), cos(angle), 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1])
        
        
        matrix = translation * rotationMatrix * translation.inverse
        
        renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<matrix_float4x4>.stride, index: 12)
        color_1 = simd_float4(0,0,1,1)
        renderEncoder.setFragmentBytes(&color_1, length: MemoryLayout<simd_float4>.stride, index: 0)
        renderEncoder.drawIndexedPrimitives(
            type: .triangle,
            indexCount: sphere.indices.count,
            indexType: .uint16,
            indexBuffer: sphere.indicesBuffer,
            indexBufferOffset: 0)
    }
    
    private func renderQuad(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBuffer(vertexBuffers[0], offset: 0, index: 0)
        //renderEncoder.setVertexBuffer(vertexBuffers[1], offset: 0, index: 1)
        renderEncoder.setVertexBuffer(vertexBuffers[2], offset: 0, index: 1)
        
        renderEncoder.drawIndexedPrimitives(
            type: .point,
            indexCount: 6,
            indexType: .uint16,
            indexBuffer: vertexBuffers[1],
            indexBufferOffset: 0)
    }
    
    private func renderObjectModel(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBuffer(vertexBuffers[0], offset: 0, index: 0)
        renderEncoder.setVertexBuffer(vertexBuffers[0], offset: 0, index: 1)
        renderEncoder.setTriangleFillMode(.lines)
        for submesh in mesh.submeshes {
            renderEncoder.drawIndexedPrimitives(
                type: .triangle,
                indexCount: submesh.indexCount,
                indexType: submesh.indexType,
                indexBuffer: submesh.indexBuffer.buffer,
                indexBufferOffset: submesh.indexBuffer.offset)
        }
        
    }
}
