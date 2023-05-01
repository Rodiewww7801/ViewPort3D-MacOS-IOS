//
//  ShaderDefs.h
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float3 normal;
};

#endif /* ShaderDefs_h */
