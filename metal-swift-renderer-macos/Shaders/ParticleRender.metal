#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float4 color [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 currentPosition;
    float3 normal;
    float4 color;
};

struct Uniforms {
    float4x4 mvp;
    float3 lightPosition;
    float4 lightColor;
    float4x4 modelMatrix;
    float3x3 normalMatrix;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]],
                             constant Uniforms& uniforms [[buffer(1)]]) {
    VertexOut out;
    out.position = uniforms.mvp * in.position;
    out.normal = uniforms.normalMatrix * in.normal;
    out.color = in.color;
    out.currentPosition = (uniforms.modelMatrix * in.position).xyz;
    return out;
}

fragment float4 fragment_main(VertexOut in [[stage_in]],
                              constant Uniforms& uniforms [[buffer(1)]]) {
    float3 normal = normalize(in.normal);
    float3 lightDirection = normalize(uniforms.lightPosition - in.currentPosition);

    float ambient = 0.15;
    float deffuse = max(dot(normal, lightDirection), 0.0);
    float intensity = ambient + deffuse;

    float3 lit = in.color.rgb * uniforms.lightColor.rgb * intensity;
    return float4(lit, in.color.a);
}
