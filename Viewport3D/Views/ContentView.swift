//
//  ContentView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}