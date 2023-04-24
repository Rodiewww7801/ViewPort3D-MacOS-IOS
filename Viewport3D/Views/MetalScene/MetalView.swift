//
//  MetalView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?
    
    var body: some View {
        MetalViewRepresentable(metalView: $metalView)
#if os(macOS)
                .frame(minWidth: 480, minHeight: 480)
#endif
            .onAppear {
                self.renderer = Renderer(metalView: metalView)
            }
    }
}

struct MetalView_Previews: PreviewProvider {
    static var previews: some View {
        MetalView()
    }
}
