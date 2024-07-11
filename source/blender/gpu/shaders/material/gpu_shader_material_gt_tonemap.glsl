const float e = 2.71828;

float W_f(float x, float e0, float e1) {
    if (x <= e0)
        return 0.0;
    if (x >= e1)
        return 1.0;
    float a = (x - e0) / (e1 - e0);
    return a * a * (3.0 - 2.0 * a);
}

float H_f(float x, float e0, float e1) {
    if (x <= e0)
        return 0.0;
    if (x >= e1)
        return 1.0;
    return (x - e0) / (e1 - e0);
}

float GTTonemapper(float x) {
    float L_x = 0.22 + 1.0 * (x - 0.22);
    float T_x = 0.22 * pow(x / 0.22, 1.33);
    float S_x = 1.0 - (1.0 - 0.532) * exp(-(2.136752 * (x - 0.532) / 1.0));
    float w0_x = 1.0 - W_f(x, 0.0, 0.22);
    float w2_x = H_f(x, 0.532, 0.532);
    float w1_x = 1.0 - w0_x - w2_x;
    float f_x = T_x * w0_x + L_x * w1_x + S_x * w2_x;
    return f_x;
}

vec3 GT_Tonemap_Vec3(vec3 x) {
    return vec3(GTTonemapper(x.r), GTTonemapper(x.g), GTTonemapper(x.b));
}

void gttonemap(float fac, vec4 col, out vec4 outcol)
{
    outcol.xyz = mix(col.xyz, GT_Tonemap_Vec3(col.xyz), fac);
    outcol.w = col.w;
}
