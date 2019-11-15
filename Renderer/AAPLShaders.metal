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

constant spvUnsafeArray<float2, 3> _87 = spvUnsafeArray<float2, 3>({ float2(0.0, 0.5), float2(-0.5), float2(0.5, -0.5) });

struct main0_out
{
    float4 color [[user(locn0)]];
    float4 gl_Position [[position]];
};

struct main0_in
{
    int2 test [[attribute(0)]];
};

vertex main0_out main0(main0_in in [[stage_in]], uint gl_VertexIndex [[vertex_id]])
{
    main0_out out = {};
    spvUnsafeArray<spvUnsafeArray<int, 2>, 3> expected;
    expected[0][0] = 127;
    expected[0][1] = 0;
    expected[1][0] = -128;
    expected[1][1] = -2;
    expected[2][0] = 120;
    expected[2][1] = -121;
    bool success = true;
    int testVal0 = in.test.x;
    int testVal1 = in.test.y;
    int expectedVal0;
    int expectedVal1;
    expectedVal0 = expected[int(gl_VertexIndex)][0];
    expectedVal1 = expected[int(gl_VertexIndex)][1];
    // This is the workaround that can make this shader works correctly on Intel Iris pro
    /*if (gl_VertexIndex == 0) {
        expectedVal0 = expected[0][0];
        expectedVal1 = expected[0][1];
    } else if (gl_VertexIndex == 1) {
        expectedVal0 = expected[1][0];
        expectedVal1 = expected[1][1];
    } else {
        expectedVal0 = expected[2][0];
        expectedVal1 = expected[2][1];
    }*/
    success = success && (testVal0 == expectedVal0);
    success = success && (testVal1 == expectedVal1);
    if (success)
    {
        out.color = float4(0.0, 1.0, 0.0, 1.0);
    }
    else
    {
        out.color = float4(1.0, 0.0, 0.0, 1.0);
    }
    out.gl_Position = float4(_87[int(gl_VertexIndex)], 0.0, 1.0);
    return out;
}

fragment float4 fragmentShader(main0_out in [[stage_in]])
{
    // Return the interpolated color.
    return in.color;
}

