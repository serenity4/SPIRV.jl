#version 450

layout(location = 0) in vec3 color;
layout(location = 0) out float something;

float do_something(vec3 color) {
    float a = 0.2;
    if (color.r > 0.2) {
        return 1.0;
    } else if (color.g < 0.1) {
        return 2.0;
    } else {
        a = 0.1;
    }
    return 3.0 + a;
}

void main() {
    something = do_something(color);
}
