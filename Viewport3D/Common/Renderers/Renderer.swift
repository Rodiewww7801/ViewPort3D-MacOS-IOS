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
    
    public var renderOptions: RenderOptions
    
    private var pipelineDescriptor: MTLRenderPipelineDescriptor!
    private var pipelineStateForModel: MTLRenderPipelineState!
    private var pipelineStateForPrimitive: MTLRenderPipelineState!
    private var depthStencilState: MTLDepthStencilState?
    private let metalView: MTKView
    
    private var uniforms: Uniforms = Uniforms()
    private var renderParameters: RenderParameters = RenderParameters()
    private var lastTime: Double = CFAbsoluteTimeGetCurrent()
    private var scene: EngineScene
    
    init(metalView: MTKView, renderOptions: RenderOptions) {
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue()
        else {
            fatalError("[Renderer]: Coud not support Metal")
        }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        self.metalView = metalView
        self.renderOptions = renderOptions
        self.depthStencilState = Renderer.buildDepthStencilState()
        self.scene = Renderer.getScene(renderChoise: renderOptions.renderChoise)
        super.init()
        
        metalView.device = Renderer.device
        metalView.delegate = self
        metalView.clearColor = MTLClearColorMake(255, 255, 255, 0)
        metalView.depthStencilPixelFormat = .depth32Float
        
        uniforms.modelMatrix = .identity
        uniforms.viewMatrix = .identity
        uniforms.projectionMatrix = .identity
        
        self.modelLogicSetup()
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
    
    deinit {
        print("[Renderer] deinit")
    }
    
    static func getScene(renderChoise: RenderChoise) -> EngineScene {
        var scene: EngineScene
        switch renderChoise {
        case .mainScene:
            scene = MainScene()
        case .vertexScene:
            scene = ArcballScene()
        case .frontOrtigraphic:
            scene = FrontOrtigraphicScene()
        case .leftOrtographic:
            scene = LeftOrtographicScene()
        case .topOrtographic:
            scene = TopOrtographicScenes()
        }
        return scene
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState? {
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .less
        descriptor.isDepthWriteEnabled = true
        let depthStencilState = Renderer.device.makeDepthStencilState(descriptor: descriptor)
        return depthStencilState
    }
    
    private func createLibrary() {
        let library = Renderer.device.makeDefaultLibrary()
        Renderer.library = library
    }
    
    private func createPipelineDescriptorForModel() {
        let vertexFunction = Renderer.library.makeFunction(name: "vertex_main")
        let fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        
        self.pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    }
    
    private func createPipelineDescriptorForPrimitive() {
        let vertexFunction = Renderer.library.makeFunction(name: "vertex_primitive")
        let fragmentFunction = Renderer.library.makeFunction(name: "fragment_main")
        
        self.pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = metalView.colorPixelFormat
        pipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
    }
    
    private func createPipelineStateForModel() {
        print("[Renderer]: createPipelineStateForModel")
        
        do {
            self.pipelineStateForModel = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("\(error)")
        }
    }
    
    private func createPipelineStateForPrimitive() {
        print("[Renderer]: createPipelineStateForPrimitive")
        
        do {
            self.pipelineStateForPrimitive = try Renderer.device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            fatalError("\(error)")
        }
    }
    
    func updateMetalView(with renderOptions: RenderOptions) {
        self.renderOptions = renderOptions
        self.scene = Renderer.getScene(renderChoise: renderOptions.renderChoise)
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
    }
}

// MARK: - Render

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene.update(size: size)
    }
    
    func draw(in view: MTKView) {
        guard
            let commandBuffer = Renderer.commandQueue.makeCommandBuffer(),
            let currentRednderPassDescriptor = view.currentRenderPassDescriptor,
            let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: currentRednderPassDescriptor)
        else {
            print("[Renderer]: Coudn't render view")
            return
        }
        
        let deltaTime = self.getDeltaTime()
        
        
        
        if renderOptions.renderChoise == .vertexScene {
            renderParameters.isRenderVertex = UInt32(1)
            renderEncoder.setTriangleFillMode(.lines)
        } else {
            renderParameters.isRenderVertex = UInt32(0)
            renderEncoder.setTriangleFillMode(.fill)
        }
        
        renderEncoder.setDepthStencilState(self.depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineStateForModel)
        
        
        scene.update(deltaTime: deltaTime)
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        scene.models.forEach { model in
            model.render(encoder: renderEncoder, uniforms: self.uniforms, renderParameters: self.renderParameters)
        }
        
        renderEncoder.endEncoding()
        
        guard let drawable = view.currentDrawable else {
            print("[Renderer]: Coudn't render view")
            return
        }
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    // MARK: - Setup Scene
    
    private func getDeltaTime() -> Float {
        let currentTime = CFAbsoluteTimeGetCurrent()
        let deltaTime = Float(currentTime - lastTime)
        lastTime = currentTime
        return deltaTime
    }
}

// MARK: - Logic setup

extension Renderer {
    
    private func modelLogicSetup() {
        createLibrary()
        createPipelineDescriptorForModel()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.modelDefaultLayout
        createPipelineStateForModel()
    }
}
