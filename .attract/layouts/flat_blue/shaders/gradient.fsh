//texture 0
uniform sampler2D u_texture;

//our screen resolution, set from Java whenever the display is resized
uniform vec2 resolution;

//"in" attributes from our vertex shader
varying vec4 vColor;
varying vec2 vTexCoord;

void main() {
    //sample our texture
    vec4 texColor = texture2D(u_texture, vTexCoord);

    //determine origin
    vec2 position = (gl_FragCoord.xy / resolution.xy) - vec2(0.5);

    //determine the vector length of the center position
    float len = length(position);

    //show our length for debugging
    gl_FragColor = vec4( vec3(len), 1.0 );
}