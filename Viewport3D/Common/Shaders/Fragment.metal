//
//  Fragment.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDefs.h"

fragment float4 fragment_main(VertexOut vertexOut [[stage_in]], constant ScreenParameters &screenParameters [[buffer(12)]]) {
    float4 sky = float4(0.34, 0.9, 1.0, 1.0);
    float4 earth = float4(0.29, 0.58, 0.2, 1.0);
    float intensity = vertexOut.normal.y + 0.5;
    return mix(earth, sky, intensity);
}


