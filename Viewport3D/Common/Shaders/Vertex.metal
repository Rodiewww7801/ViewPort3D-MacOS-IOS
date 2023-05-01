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
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[stage_in]], constant Uniforms &uniforms [[buffer(1)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
    VertexOut out {
        .position = position
    };
    return  out;
}

constant float3 vertices[6] = {
    float3(-1,  1,  0),    // triangle 1
    float3( 1, -1,  0),
    float3(-1, -1,  0),
    float3(-1,  1,  0),    // triangle 2
    float3( 1,  1,  0),
    float3( 1, -1,  0)
};

vertex VertexOut vertex_primitive(uint vertexId [[vertex_id]]) {
    float4 position = float4(vertices[vertexId],1);
    VertexOut vertexOut {
      .position = position
    };
    return vertexOut;
}