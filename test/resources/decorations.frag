#version 450

layout(set = 3, binding = 2) uniform writeonly image2D image;

layout(location = 0) in vec4 position;
layout(location = 0) out vec4 color;

void main() {
    color = position;
}
