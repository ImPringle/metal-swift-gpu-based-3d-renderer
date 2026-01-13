#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float2 position [[attribute(0)]];
};

struct VSOut {
    float4 position [[position]];
};

vertex VSOut vs_main(VertexIn in [[stage_in]]) {
    VSOut out;
    out.position = float4(in.position, 0.0, 1.0);
    return out;
}

fragment float4 fs_main() {
    // Hot pink, like SDL_SetRenderDrawColor(renderer, 255, 105, 180, 255)
    
    // BLUE
//    return float4(0, 230/255.0, 255/255.0, 1.0);
    
    // PINK
    return float4(1.0, 105.0/255.0, 180.0/255.0, 1.0);
}
