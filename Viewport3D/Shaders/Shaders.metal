//
//  Shaders.metal
//  Viewport3D
//
//  Created by Rodion Hladchenko on 09.04.2023.
//

//#include <metal_stdlib>
//using namespace metal;
//
//struct VertexIn {
//    float4 position [[attribute(0)]];
//    float3 normal [[attribute(1)]];
//
//};
//
//struct VertexOut {
//    float4 position [[position]];
//    float3 normal;
//};
//
//
//float radians(float degrees);
//static inline float4x4 float4x4_rotation(float radians, vector_float3 vector);
//
//vertex VertexOut vertex_main(const VertexIn vertex_in [[stage_in]]) {
//    VertexOut out;
//    out.position = vertex_in.position;
//    out.position = float4(out.position.x, out.position.y, out.position.z, 1.3);
//    out.normal = vertex_in.normal;
//
//    float rotation = radians(90);
//    float4x4 rotationMatrix = float4x4_rotation(rotation, vector_float3(0, 1, 0));
//    out.position = out.position * rotationMatrix;
//
//    return  out;
//}
//
//float radians(float degrees) {
//    return  (degrees / 180.0) * M_PI_F;
//}
//
//static inline float4x4 float4x4_rotation(float radians, vector_float3 vector) {
//    float c = cos(radians);
//    float s = sin(radians);
//
//    simd_float4 xVector = simd_float4(1, 0, 0, 0);
//    simd_float4 yVector = simd_float4(0, 1, 0, 0);
//    simd_float4 zVector = simd_float4(0, 0, 1, 0);
//
//    if (vector.x != 0.0) {
//        xVector = simd_float4(  1,  0,  0,  0);
//        yVector = simd_float4(  0,  c,  -s, 0);
//        zVector = simd_float4(  0,  s,  c,  0);
//    } else if (vector.y != 0.0) {
//        xVector = simd_float4(  c,  0,  s,  0);
//        yVector = simd_float4(  0,  1,  0,  0);
//        zVector = simd_float4(  -s, 0,  c,  0);
//    } else if (vector.z != 0.0) {
//        xVector = simd_float4(  c,  -s, 0,  0);
//        yVector = simd_float4(  s,  c,  0,  0);
//        zVector = simd_float4(  0,  0,  1,  0);
//    }
//
//    return float4x4(xVector,
//                    yVector,
//                    zVector,
//                    simd_float4(0,0,0,1)
//                    );
//}
//
//fragment float4 fragment_main() {
//    return float4(0,0,1,1);
//}

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float pointSize [[point_size]];
};

vertex VertexOut vertex_main(
                             VertexIn vertexIn [[stage_in]],
                             constant float &timer [[buffer(11)]])
{
    VertexOut vertexOut {
        .position = vertexIn.position,
        .color = vertexIn.color,
        .pointSize = 30
    };
    return vertexOut;
}

fragment float4 fragment_main(VertexOut vertexOut [[stage_in]]) {
    return vertexOut.color;
}
