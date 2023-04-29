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
    
    @State private var showGrid = true
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                MetalView()
                    .border(Color(.black), width: 0.5)
                if showGrid {
                    GridView()
                }
                
                VStack(alignment: .trailing) {
                   Spacer()
                    HStack (alignment: .bottom) {
                        Spacer()
                        Toggle("Show grid", isOn: $showGrid)
                        .padding()
                    }
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .border(.black)
            
            ZStack(alignment: .top) {
                HStack {
                    Rectangle()
                        .foregroundColor(MultiplatformColor.blue)
                        .frame(width: 20, height: 20)
                    Text("Transformed")
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .frame(width: 20, height: 20)
                    Text("Original")
                    
                   
                }
            }
        }.padding()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
