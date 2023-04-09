//
//  Shaders.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
};

vertex float4 vertex_main(const VertexIn vertex_in [[stage_in]]) {
    return  vertex_in.position;
}

fragment float4 fragment_main() {
    return float4(0,0,1,1);
}
