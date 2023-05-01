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
    
    private var pipelineDescriptor: MTLRenderPipelineDescriptor!
    private var pipelineState: MTLRenderPipelineState!
    private let metalView: MTKView
    private var uniforms: Uniforms = Uniforms()
    
    private let resourceName: String = "SVS61UZAH4OIDVNG1PSGCOM2D"
    private var timer: Float = 0.0
    private var primitive: Primitive?
    private var model: Model?
    
    
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
        
        let translation = float4x4(translation: [0, 0, 0])
        let rotation = float4x4(rotation: [0,0,Float(45).degreesToRadians])
        self.uniforms.modelMatrix = translation
        self.uniforms.viewMatrix =  float4x4(rotation: [0, Float(90).degreesToRadians, 0]).inverse * float4x4(translation: [-3,0,0]).inverse
        
        modelLogicSetup()
//        quadLogicSetup()
//        triangleLogicSetup()
//        sphereLogicSetup()
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
    
    private func createLibrary() {
        let library = Renderer.device.makeDefaultLibrary()
        Renderer.library = library
    }
    
    private func createPipelineDescriptor() {
        let vertexFunction = Renderer.library.makeFunction(name: "vertex_main")
        let fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        
        self.pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
    }
    
    private func createPipelineState() {
        do {
            self.pipelineState = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("\(error)")
        }
    }
}

// MARK: - Render

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        setupFOV()
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
        
        
        setupUniform(renderEncoder: renderEncoder)
        setupTimer(renderEncoder: renderEncoder)
       
        renderObjectModel(renderEncoder: renderEncoder)
       
//        renderPrimitive(renderEncoder: renderEncoder)
        
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            print("Coudn't render view")
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    private func setupFOV() {
        let aspect = Float(self.metalView.bounds.width) / Float(self.metalView.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(45), near: 0.1, far: 100, aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
    }
    
    private func setupTimer(renderEncoder: MTLRenderCommandEncoder) {
        timer += 0.005
        let currentTime = sin(timer)
        self.uniforms.modelMatrix = float4x4(rotation: [0, currentTime, 0])
    }
    
    private func setupUniform(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
    }
    
    private func renderPrimitive(renderEncoder: MTLRenderCommandEncoder) {
        guard let primitive = primitive else { return }
        primitive.renderPrimitive(encoder: renderEncoder)
    }
    
    private func renderObjectModel(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setTriangleFillMode(.lines)
        model?.render(encoder: renderEncoder)
    }
}

// MARK: - Logic setup

extension Renderer {
    private func triangleLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createTriangle()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.primitiveDefaultLayout
        createPipelineState()
    }
    
    private func sphereLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createSphere()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.primitiveDefaultLayout
        createPipelineState()
    }
    
    private func quadLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createQuad()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.primitiveDefaultLayout
        createPipelineState()
    }
    
    private func modelLogicSetup() {
        createLibrary()
        createPipelineDescriptor()
        createModel()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.modelDefaultLayout
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
        self.primitive = quad
    }
    
    private func createModel() {
        let model = Model(device: Renderer.device, name: resourceName)
        self.model = model
    }
}
