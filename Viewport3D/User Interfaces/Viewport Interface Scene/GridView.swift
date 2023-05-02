//
//  GridView.swift
//  Viewport3D
//
//  Created by Rodion Hladchenko on 24.04.2023.
//

import SwiftUI

struct GridView: View {
    
    var body: some View {
        GeometryReader { geometry in
            ZStack() {
                HStack {
                    ForEach(0..<Int(geometry.size.width) / 20, id: \.self) { _ in
                        Spacer()
                        Divider()
                    }
                }
                
                VStack {
                    ForEach(0..<Int(geometry.size.height) / 20, id: \.self) { _ in
                        Spacer()
                        Divider()
                    }
                }
                
                HStack {
                    Rectangle()
                        .foregroundColor(Color.black)
                        .frame(width: 1)
                }
                
                VStack {
                    Rectangle()
                        .foregroundColor(Color.black)
                        .frame(height: 1)
                }
                
            }
        }
    
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView()
    }
}
