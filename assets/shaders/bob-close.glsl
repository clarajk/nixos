vec4 animation(vec2 uv) {
    float progress = umbriel_clamped_progress;

    float y_offset = 0.0;

    // Bob phase: first 25% of the animation.
    if (progress < 0.25) {
        float t = progress / 0.25;

        // Parabola:
        // starts at 0, rises 40 units, returns to 0.
        y_offset =
            -40.0
            * (1.0 - 4.0 * (t - 0.5) * (t - 0.5));
    }

    // Slide phase: remaining 75%.
    else {
        float slide_progress =
            (progress - 0.25) / 0.75;

        y_offset =
            -slide_progress
            * (umbriel_size.y + 100.0);
    }

    vec2 coords = uv * umbriel_size;

    coords.y += y_offset;

    vec2 sample_uv = coords / umbriel_size;

    return umbriel_sample(sample_uv);
}
