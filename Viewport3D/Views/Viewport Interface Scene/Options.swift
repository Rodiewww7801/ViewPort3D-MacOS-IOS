//
//  Options.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

import SwiftUI

enum RenderChoise {
    case model
    case primitive
}

class RenderOptions: ObservableObject {
    @Published var renderChoise: RenderChoise = .model
}
