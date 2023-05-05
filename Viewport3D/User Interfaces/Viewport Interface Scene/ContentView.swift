//
//  ContentView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI

struct ContentView: View {
    private let originalColor = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let size: CGFloat = 400
    @ObservedObject var renderOptions: RenderOptions = RenderOptions()
    
    @State private var showGrid = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                MetalView(renderOptions: renderOptions)
                    .border(Color(.black), width: 0.5)
                if showGrid {
                    GridView()
                }
            }
            .border(.black)
            
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Settings").bold()
                    Toggle("Show grid", isOn: $showGrid)
                    Picker("Render options:", selection: $renderOptions.renderChoise, content: {
                        Text("Model").tag(RenderChoise.model)
                        Text("Texture").tag(RenderChoise.primitive)
                    })
                }.frame(maxWidth: .infinity)
            }
        }.padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
