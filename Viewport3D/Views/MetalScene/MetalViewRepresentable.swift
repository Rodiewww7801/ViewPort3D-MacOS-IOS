//
//  MetalViewRepresentable.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI
import MetalKit

#if os(macOS)
typealias ViewRepresentable = NSViewRepresentable
#elseif os(iOS)
typealias ViewRepresentable = UIViewRepresentable
#endif

struct MetalViewRepresentable: ViewRepresentable {
    @Binding var metalView: MTKView
    var renderer: Renderer?
    @ObservedObject var renderOptions: RenderOptions
    
#if os(macOS)
    func makeNSView(context: Context) -> MTKView {
        return metalView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        updateMetalView()
    }
#elseif os(iOS)
    func makeUIView(context: Context) -> some UIView {
        return metalView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        updateMetalView()
    }
#endif
    
    private func updateMetalView() {
        renderer?.renderOptions  = renderOptions
        print("[Renderer]: updateMetalView")
    }
}

struct ContentRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        let renderOptions = RenderOptions()
        renderOptions.renderChoise = .model
        return MetalView(renderOptions: renderOptions)
    }
}
