vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;

    // Tilt from 90 degrees (flat) to 0 degrees (upright)
    float tilt = (1.0 - progress) * 1.57079632;

    // Convert normalized coordinates to logical window coordinates.
    vec2 coords = uv * umbriel_size;

    // Pivot around the bottom edge.
    coords.y = umbriel_size.y - coords.y;

    float dist_from_pivot = coords.y;

    // Calculate projected 3D position.
    float z_offset = -dist_from_pivot * sin(tilt);
    float y_compressed = dist_from_pivot * cos(tilt);

    float perspective = 600.0;
    float perspective_scale =
        perspective / (perspective + z_offset);

    coords.x =
        (coords.x - umbriel_size.x * 0.5)
        * perspective_scale
        + umbriel_size.x * 0.5;

    coords.y = y_compressed * perspective_scale;

    // Convert back from bottom-origin coordinates.
    coords.y = umbriel_size.y - coords.y;

    vec2 sample_uv = coords / umbriel_size;

    vec4 color = umbriel_sample(sample_uv);

    // Brighten as the window rises.
    float brightness = 0.4 + 0.6 * progress;
    color.rgb *= brightness;

    // Preserve premultiplied alpha semantics.
    return color * progress;
}
