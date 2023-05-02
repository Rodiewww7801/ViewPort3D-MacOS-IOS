//
//  Shaders.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDefenitions.h"

struct VertexIn {
    float4 position [[attribute(PositionAttribute)]];
    float3 normal [[attribute(NormalAttribute)]];
    float2 uv [[attribute(UVAttribute)]];
};

vertex VertexOut vertex_main(const VertexIn vertex_in [[stage_in]],
                             constant Uniforms &uniforms [[buffer(UniformsBuffer)]]) {
    float4 position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertex_in.position;
    VertexOut out {
        .position = position,
        .normal = vertex_in.normal,
        .uv = vertex_in.uv
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
