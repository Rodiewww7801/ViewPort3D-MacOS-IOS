//
//  Shaders.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

#include <metal_stdlib>
using namespace metal;

#import "Common.h"

struct VertexIn {
    float4 position [[attribute(0)]];
    //float3 normal [[attribute(1)]];

};

struct VertexOut {
    float4 position [[position]];
    //float3 normal;
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
    VertexOut out {
        .position = position
    };
    return  out;
}

fragment float4 fragment_main() {
    return float4(0,0,1,1);
}

//#include <metal_stdlib>
//using namespace metal;
//
//struct VertexIn {
//    float4 position [[attribute(0)]];
//    float4 color [[attribute(1)]];
//};
//
//struct VertexOut {
//    float4 position [[position]];
//    //float4 color;
//    float pointSize [[point_size]];
//};
//
//vertex VertexOut vertex_main(VertexIn vertexIn [[stage_in]],
//                             constant float &timer [[buffer(11)]],
//                             constant float4x4 &position [[buffer(12)]])
//{
//    float4 translation = position * vertexIn.position;
//    //newPosition.y += timer;
//    VertexOut vertexOut =  {
//        .position = translation,
//        //.color = float4(0,0,1,1),
//        .pointSize = 20
//    };
//    return vertexOut;
//}
//
//fragment float4 fragment_main(constant float4 &colorBuffer [[buffer(0)]]) {
//    return colorBuffer;
//}
