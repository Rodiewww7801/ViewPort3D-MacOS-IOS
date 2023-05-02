//
//  Fragment.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 01.05.2023.
//

#include <metal_stdlib>
using namespace metal;
#import "Common.h"
#import "ShaderDefenitions.h"

fragment float4 fragment_main(VertexOut vertexOut [[stage_in]],
                              texture2d<float> baseColorTexture [[texture(BaseColor)]],
                              constant ScreenParameters &screenParameters [[buffer(ScreenParametersBuffer)]]) {
    constexpr sampler textureSampler;
    float3 baseColor = baseColorTexture.sample(textureSampler, vertexOut.uv).rgb;
    return float4(baseColor,1);
}


