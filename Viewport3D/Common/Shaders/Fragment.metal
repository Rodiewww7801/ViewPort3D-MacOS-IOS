//
//  Fragment.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"


struct VertexIn {
    float4 position [[attribute(0)]];
};

struct VertexOut {
    float4 position [[position]];
};

fragment float4 fragment_main(VertexOut vertexIn [[stage_in]]) {
    float color;
    vertexIn.position.x < 200 ? color = 0 : color = 1;
    return float4(color,color,color,1);
}


