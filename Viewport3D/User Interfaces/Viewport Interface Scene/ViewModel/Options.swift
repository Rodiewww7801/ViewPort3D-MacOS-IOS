//
//  Options.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

import SwiftUI

enum RenderChoise: Int, CaseIterable {
    case mainScene
    case vertexScene
    case frontOrtigraphic
    case leftOrtographic
    case topOrtographic
    
    var getName: String {
        switch self {
            
        case .mainScene:
            return "Main scene"
        case .vertexScene:
            return "Vertex scene"
        case .frontOrtigraphic:
            return "Front Ortographic"
        case .leftOrtographic:
            return "Left Ortographic"
        case .topOrtographic:
            return "Top Ortographic"
        }
    }
}

class RenderOptions: ObservableObject {
    @Published var renderChoise: RenderChoise
    
    init(renderChoise: RenderChoise) {
        self.renderChoise = renderChoise
    }
}
