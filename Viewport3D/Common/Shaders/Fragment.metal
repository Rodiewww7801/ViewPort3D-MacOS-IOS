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
                              constant RenderParameters &fragmentParameters [[buffer(RenderParametersBuffer)]]) {
    constexpr sampler textureSampler(filter:: linear, address:: mirrored_repeat, mip_filter::linear);
    float3 baseColor = baseColorTexture.sample(textureSampler, vertexOut.uv * fragmentParameters.tiling).rgb;
    return float4(baseColor,1);
}


