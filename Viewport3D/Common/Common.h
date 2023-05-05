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

typedef struct {
    ScreenParameters screenParameters;
    uint tiling;
} RenderParameters;

typedef enum {
    VertexBuffer = 0,
    UVBuffer = 1,
    UniformsBuffer = 11,
    RenderParametersBuffer = 12
} BufferIndices;

typedef enum {
    PositionAttribute = 0,
    NormalAttribute = 1,
    UVAttribute = 2
} AttributesIndices;

typedef enum {
    BaseColor = 0
} TextureIndices;

#endif /* Common_h */
