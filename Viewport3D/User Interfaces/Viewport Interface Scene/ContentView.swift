//
//  ContentView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var renderOptions: RenderOptions = RenderOptions(renderChoise: .mainScene)
    private let originalColor = Color(red: 0.8, green: 0.8, blue: 0.8)
    private let size: CGFloat = 400
    private let aspectRenderPreviews: CGFloat = 0.2
    
    @State private var showGrid = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                MetalView(renderOptions: renderOptions)
                    .border(Color(.black), width: 0.5)
#if os(macOS)
                    .frame(minWidth: 480, minHeight: 480)
#endif
                if showGrid {
                    GridView()
                }
                
                GeometryReader { geomentry in
                    ScrollView(showsIndicators: false) {
                        ForEach(RenderChoise.allCases, id: \.self) { choise in
                            if choise == renderOptions.renderChoise {
                                EmptyView()
                            } else {
                                MetalView(renderOptions: RenderOptions(renderChoise: choise))
                                    .frame(width: geomentry.size.width * aspectRenderPreviews,
                                           height: geomentry.size.height * aspectRenderPreviews)
                                    .border(.black)
                            }
                        }
                    }
                }
            }
            .border(.black)
            
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Settings").bold()
                    Toggle("Show grid", isOn: $showGrid)
                    Picker("Render options:", selection: $renderOptions.renderChoise, content: {
                        ForEach(RenderChoise.allCases, id: \.rawValue) { renderChoise in
                            Text("\(renderChoise.getName)").tag(renderChoise)
                        }
                        
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
