//
//  Shaders.metal
//  A-year-of-SwiftUI
//
//  Created by Quentin Fasquel on 18/01/2024.
//

#include <metal_stdlib>
using namespace metal;

// MARK: - Color Shaders

[[ stitchable ]] half4 checkerboard(float2 position, half4 currentColor, float size, half4 newColor) {
    uint2 posInChecks = uint2(position.x / size, position.y / size);
    bool isColor = (posInChecks.x ^ posInChecks.y) & 1;
    return isColor ? currentColor : half4(0.0, 0.0, 0.0, 0.0);
}

[[ stitchable ]] half4 noise(float2 position, half4 currentColor, float time) {
    float value = fract(sin(dot(position / 2 + time, float2(12.9898, 78.233))) * 43758.5453);
    return half4(value, value, value, 1) * currentColor;
}

// MARK: - Distortion Shaders

[[ stitchable ]] float2 simpleWave(float2 position, float time) {
    return position + float2(sin(time + position.y / 20), sin(time + position.x / 20)) * 5;
}

[[ stitchable ]] float2 complexWave(float2 position, float time, float2 size, float speed, float strength, float frequency) {
    float2 normalizedPosition = position / size;
    float moveAmount = time * speed;

    position.x += sin((normalizedPosition.x + moveAmount) * frequency) * strength;
    position.y += cos((normalizedPosition.y + moveAmount) * frequency) * strength;

    return position;
}

// MARK: - Layer Shaders

#include <SwiftUI/SwiftUI_Metal.h>

[[ stitchable ]] half4 pixellate(float2 position, SwiftUI::Layer layer, float strength) {
    float min_strength = max(strength, 0.0001);
    
    float coord_x = min_strength * round(position.x / min_strength);
    float coord_y = min_strength * round(position.y / min_strength);
    return layer.sample(float2(coord_x, coord_y));
}
