//
//  MetalView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI
import MetalKit

struct MetalView: View {
    @ObservedObject var renderOptions: RenderOptions
    
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?
    
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView, renderer: renderer, renderOptions: renderOptions)
#if os(macOS)
                .frame(minWidth: 480, minHeight: 480)
#endif
            .onAppear {
                self.renderer = Renderer(metalView: metalView, renderOptions: renderOptions)
            }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        let renderOptions = RenderOptions()
        renderOptions.renderChoise = .model
        return MetalView(renderOptions: renderOptions)
    }
}
