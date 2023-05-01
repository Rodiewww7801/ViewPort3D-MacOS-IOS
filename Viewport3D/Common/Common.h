//
//  Common.h
//  Viewport3D
//
//  Created by Rodion Hladchenko on 30.04.2023.
//

#ifndef Common_h
#define Common_h

#import <simd/simd.h>

typedef struct {
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float4x4 projectionMatrix;
} Uniforms;

typedef struct {
    uint width;
    uint height;
} ScreenParameters;

typedef enum {
    VertexBuffer = 0,
    UniformsBuffer = 11,
    ParamsBuffer = 12
} BufferIndices;

#endif /* Common_h */
