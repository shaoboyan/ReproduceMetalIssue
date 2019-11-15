#pragma clang diagnostic ignored "-Wmissing-prototypes"
#pragma clang diagnostic ignored "-Wmissing-braces"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

template<typename T, size_t Num>
struct spvUnsafeArray
{
    T elements[Num ? Num : 1];
    
    thread T& operator [] (size_t pos) thread
    {
        return elements[pos];
    }
    constexpr const thread T& operator [] (size_t pos) const thread
    {
        return elements[pos];
    }
    
    device T& operator [] (size_t pos) device
    {
        return elements[pos];
    }
    constexpr const device T& operator [] (size_t pos) const device
    {
        return elements[pos];
    }
    
    constexpr const constant T& operator [] (size_t pos) const constant
    {
        return elements[pos];
    }
    
    threadgroup T& operator [] (size_t pos) threadgroup
    {
        return elements[pos];
    }
    constexpr const threadgroup T& operator [] (size_t pos) const threadgroup
    {
        return elements[pos];
    }
};

typedef struct
{
    
    // The [[position]] attribute of this member indicates that this value
    // is the clip space position of the vertex when this structure is
    // returned from the vertex function.
    float4 position [[position]];

    // Since this member does not have a special attribute, the rasterizer
    // interpolates its value with the values of the other triangle vertices
    // and then passes the interpolated value to the fragment shader for each
    // fragment in the triangle.
    float4 color;

} RasterizerData;

vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]])
{
    RasterizerData out;
    
    spvUnsafeArray<spvUnsafeArray<float, 2>, 3> expected;
    expected[0][0] = 0.0;
    expected[0][1] = 0.5;
    expected[1][0] = -0.5;
    expected[1][1] = 0.0;
    expected[2][0] = 0.5;
    expected[2][1] = -0.5;

    // Index into the array of positions to get the current vertex.
    // The positions are specified in pixel dimensions (i.e. a value of 100
    // is 100 pixels from the origin).

    // To convert from positions in pixel space to positions in clip-space,
    //  divide the pixel coordinates by half the size of the viewport.
    out.position = float4(expected[int(vertexID)][0], expected[int(vertexID)][1] ,0.0, 1.0);
   
    // Pass the input color directly to the rasterizer.
    out.color = float4(1.0, 0.0, 0.0, 1.0);

    return out;
}

fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    // Return the interpolated color.
    return in.color;
}

