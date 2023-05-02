//
//  Common + Extensions.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 02.05.2023.
//

import Foundation

extension BufferIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}

extension AttributesIndices {
    var index: Int  {
        return Int(self.rawValue)
    }
}

extension TextureIndices {
    var index: Int {
        return Int(self.rawValue)
    }
}
