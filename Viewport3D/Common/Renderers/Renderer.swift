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

    private let animeModelResourceName: String = "SVS61UZAH4OIDVNG1PSGCOM2D"
    private var timer: Float = 0.0
    private var primitive: Primitive?
    private var animeModel: Model?
    private var groundModel: Model?
    
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
        
        super.init()
        
        metalView.device = Renderer.device
        metalView.delegate = self
        metalView.clearColor = MTLClearColorMake(255, 255, 255, 0)
        metalView.depthStencilPixelFormat = .depth32Float
        
        uniforms.modelMatrix = .identity
        uniforms.viewMatrix = .identity
        uniforms.projectionMatrix = .identity
        
        AnimeModelLogicSetup()
        groundModelLogicSetup()
        quadLogicSetup()
        
        mtkView(metalView, drawableSizeWillChange: metalView.bounds.size)
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
}

// MARK: - Draw

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        setupFOV()
        setupScreenParameters(size)
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
        setupViewPosition()
        
        switch renderOptions.renderChoise {
        case .model:
            renderEncoder.setDepthStencilState(self.depthStencilState)
            renderEncoder.setRenderPipelineState(pipelineStateForModel)
            
            setupTimer()
            
            setupTransformForAnimeModel()
            setupUniform(renderEncoder: renderEncoder)
            renderAnimeModel(renderEncoder: renderEncoder)
            
            setupTransformForGroundModel()
            setupUniform(renderEncoder: renderEncoder)
            renderGroundModel(renderEncoder: renderEncoder)
        case .primitive:
            renderEncoder.setRenderPipelineState(pipelineStateForPrimitive)
            renderQuad(renderEncoder: renderEncoder)
        default:
            break
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
    
    private func setupRenderParameters(encoder: MTLRenderCommandEncoder) {
        encoder.setFragmentBytes(&renderParameters, length: MemoryLayout<RenderParameters>.stride, index: RenderParametersBuffer.index)
    }
    
    private func setupScreenParameters(_ size: CGSize) {
        renderParameters.screenParameters.width = UInt32(size.width)
        renderParameters.screenParameters.height = UInt32(size.height)
    }
    
    private func setupFOV() {
        let aspect = Float(self.metalView.bounds.width) / Float(self.metalView.bounds.height)
        let projectionMatrix = float4x4(projectionFov: Float(70).degreesToRadians, near: 0.1, far: 100, aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
    }
    
    private func setupViewPosition() {
        let translation = float4x4(translation: [0,1.3,-3]).inverse
        let sinTimer = sin(timer)
        let rotation = float4x4(rotation: [0, sinTimer, 0]).inverse
        self.uniforms.viewMatrix = translation * rotation
    }
    
    private func setupTimer() {
        timer += 0.005
    }
    
    private func setupUniform(renderEncoder: MTLRenderCommandEncoder) {
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: UniformsBuffer.index)
    }
    
    private func setupTransformForAnimeModel() {
        guard let model = animeModel else { return }
        
        model.transform.position = [0,1.3,0]
        model.transform.rotation = [0, 0 + Float(-90).degreesToRadians , 0]
        
        uniforms.modelMatrix = model.transform.modelMatrix
    }
    
    private func setupTransformForGroundModel() {
        guard let groundModel = groundModel else { return }
        
        groundModel.transform.scale = 40
        groundModel.transform.rotation = [0, 0, 0 ]
        
        uniforms.modelMatrix = groundModel.transform.modelMatrix
    }
    
// MARK: - Render functions
    
    private func renderQuad(renderEncoder: MTLRenderCommandEncoder) {
        setupRenderParameters(encoder: renderEncoder)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
    }
    
    private func renderPrimitive(renderEncoder: MTLRenderCommandEncoder) {
        guard let primitive = primitive else { return }
        primitive.renderPrimitive(encoder: renderEncoder)
    }
    
    private func renderAnimeModel(renderEncoder: MTLRenderCommandEncoder) {
        guard let animeModel = animeModel else { return }
        renderEncoder.setTriangleFillMode(.fill)
        animeModel.tiling = UInt32(1)
        renderParameters.tiling = animeModel.tiling
        setupRenderParameters(encoder: renderEncoder)
        animeModel.render(encoder: renderEncoder)
    }
    
    private func renderGroundModel(renderEncoder: MTLRenderCommandEncoder) {
        guard let groundModel = groundModel else { return }
        self.groundModel?.tiling = UInt32(64)
        renderParameters.tiling = groundModel.tiling
        setupRenderParameters(encoder: renderEncoder)
        groundModel.render(encoder: renderEncoder)
    }
}

// MARK: - Logic setup

extension Renderer {
    private func triangleLogicSetup() {
        createLibrary()
        createPipelineDescriptorForPrimitive()
        createTriangle()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.primitiveDefaultLayout
        createPipelineStateForPrimitive()
    }
    
    private func sphereLogicSetup() {
        createLibrary()
        createPipelineDescriptorForPrimitive()
        createSphere()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.primitiveDefaultLayout
        createPipelineStateForPrimitive()
    }
    
    private func quadLogicSetup() {
        createLibrary()
        createPipelineDescriptorForPrimitive()
        createPipelineStateForPrimitive()
    }
    
    private func modelLogicSetup() {
        createLibrary()
        createPipelineDescriptorForModel()
        self.pipelineDescriptor.vertexDescriptor = MTLVertexDescriptor.modelDefaultLayout
        createPipelineStateForModel()
    }
    
    private func AnimeModelLogicSetup() {
        createAnimeModel()
        modelLogicSetup()
    }
    
    private func groundModelLogicSetup() {
        self.groundModel = Model(device: Renderer.device, name: "plane")
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
    
    private func createAnimeModel() {
        let model = Model(device: Renderer.device, name: animeModelResourceName)
        self.animeModel = model
    }
}
