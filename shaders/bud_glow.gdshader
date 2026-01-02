shader_type canvas_item;

// --- Couleur glow ---
uniform vec3 glow_color = vec3(0.545, 0.427, 0.611); // #8b6d9c en RGB normalisé
uniform float color_tolerance = 0.02;               // tolérance pour sélectionner les pixels

// --- Paramètres de glow ---
uniform float glow_strength : hint_range(0.0, 1.0) = 0.4;  // intensité du glow
uniform float pulse_speed = 2.0;                            // vitesse de pulsation
uniform float halo_strength = 2.0;                          // intensité de la diffusion autour

// --- Modulate.v du TileMapLayer (exporté pour chaque layer) ---
uniform float node_value = 1.0;  // mettre 1.0 pour frontground, 0.9 mid, 0.8 background

// --- Conversion RGB <-> HSV pour manipuler saturation/valeur ---
vec3 rgb_to_hsv(vec3 c) {
    vec4 K = vec4(0., -1./3., 2./3., -1.);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
    float d = q.x - min(q.w, q.y);
    float e = 1e-10;
    return vec3(
        abs(q.z + (q.w - q.y) / (6. * d + e)),
        d / (q.x + e),
        q.x
    );
}

vec3 hsv_to_rgb(vec3 c) {
    vec3 rgb = clamp(abs(mod(c.x * 6. + vec3(0,4,2), 6.) - 3.) - 1., 0., 1.);
    return c.z * mix(vec3(1.), rgb, c.y);
}

void fragment() {
    vec4 tex = texture(TEXTURE, UV);

    // Applique le modulate.v du layer
    vec3 base_rgb = tex.rgb * node_value;
    vec3 final_rgb = base_rgb;

    // Pulsation douce
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);

    // --- Glow principal (pixel source) ---
    if (distance(tex.rgb, glow_color) < color_tolerance) {
        vec3 hsv = rgb_to_hsv(base_rgb);
        hsv.y = min(1.0, hsv.y + glow_strength * pulse); // plus saturé
        hsv.z = min(1.0, hsv.z + glow_strength * pulse); // plus lumineux
        final_rgb = hsv_to_rgb(hsv);
    }

    // --- Halo / diffusion sur 1 pixel ---
    vec2 px = TEXTURE_PIXEL_SIZE;
    float halo = 0.0;
    halo += step(distance(texture(TEXTURE, UV + vec2(px.x, 0.0)).rgb, glow_color), color_tolerance);
    halo += step(distance(texture(TEXTURE, UV - vec2(px.x, 0.0)).rgb, glow_color), color_tolerance);
    halo += step(distance(texture(TEXTURE, UV + vec2(0.0, px.y)).rgb, glow_color), color_tolerance);
    halo += step(distance(texture(TEXTURE, UV - vec2(0.0, px.y)).rgb, glow_color), color_tolerance);
    halo = clamp(halo * 0.25 * halo_strength * node_value, 0.0, 1.0);

    // Ajoute la diffusion autour du pixel, mais garde la teinte d'origine
    final_rgb += glow_color * halo * pulse;

    // --- Sortie finale ---
    COLOR = vec4(final_rgb, tex.a);
}
