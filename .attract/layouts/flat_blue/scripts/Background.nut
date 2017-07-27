/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

Background class

*/



class Background
{

    settings = null;

    bgart = null;
    bgartmask_horiz = null;
    bgartmask_vert = null;
    bgart_surface = null;
    wheel_shadow = null;
    wheel_dropshadow = null;
    wheel_art = null;
    shader_crt = null;
    shader_bloom = null;

    constructor(layout_settings)
    {
        settings = layout_settings.bg;

        setup_shaders();
        draw();

        fe.add_transition_callback(this, "update");
    }

    function setup_shaders()
    {
        // disable shader for low resolutions because it looks terrible!
        if (settings.lowres) { settings.crt_shader = "Disabled"; }

        if (settings.crt_shader == "Enabled" && ShadersAvailable)
        {
            shader_crt = fe.add_shader(Shader.VertexAndFragment, "shaders/CRT-lottes.vsh", "shaders/CRT-lottes_rgb32_dir.fsh");
            // APERATURE_TYPE
            // 0 = VGA style shadow mask.
            // 1.0 = Very compressed TV style shadow mask.
            // 2.0 = Aperture-grille.
            shader_crt.set_param("aperature_type", 2.0);
            // Hardness of Scanline -8.0 = soft -16.0 = medium
            shader_crt.set_param("hardScan", -20.0);
            // Hardness of pixels in scanline -2.0 = soft, -4.0 = hard
            shader_crt.set_param("hardPix", -5.0);
            //Sets how dark a "dark subpixel" is in the aperture pattern.
            shader_crt.set_param("maskDark", 0.4);
            //Sets how dark a "bright subpixel" is in the aperture pattern
            shader_crt.set_param("maskLight", 1.5);
            // 1.0 is normal saturation. Increase as needed.
            shader_crt.set_param("saturation", 1.1);
            //0.0 is 0.0 degrees of Tint. Adjust as needed.
            shader_crt.set_param("tint", 0.0);
            //Drops the final color value by this amount if GAMMA_CONTRAST_BOOST is defined
            shader_crt.set_param("blackClip", 0.02);
            //Multiplies the color values by this amount if GAMMA_CONTRAST_BOOST is defined
            shader_crt.set_param("brightMult", 1.2);
            // Standard Shader stuff.
            shader_crt.set_texture_param("mpass_texture");

            shader_bloom = fe.add_shader(Shader.Fragment, "shaders/bloom.fsh");
            shader_bloom.set_param("bloom_spread", 0.000695);
            shader_bloom.set_param("bloom_power", 0.228);
            shader_bloom.set_texture_param("mpass_texture");
        }
        else
        {
            settings.crt_shader = "Disabled";
        }
    }

    function draw()
    {
        fe.add_image(settings.image, settings.pos.x, settings.pos.y, settings.dimensions.w, settings.dimensions.h);

        if (settings.crt_shader == "Disabled")
        {
            bgart = PreserveArt("snap", settings.pos.x, settings.pos.y, settings.dimensions.w, settings.dimensions.h);

            bgartmask_horiz = PreserveImage("images/scanlines_horiz.png", settings.pos.x, settings.pos.y, settings.dimensions.w, settings.dimensions.h);
            bgartmask_vert = PreserveImage("images/scanlines_vert.png", settings.pos.x, settings.pos.y, settings.dimensions.w, settings.dimensions.h);

            bgartmask_horiz.alpha = settings.scanline_strength;
            bgartmask_vert.alpha = settings.scanline_strength;
        }
        else
        {
            bgart_surface = fe.add_surface(settings.dimensions.w, settings.dimensions.h);
            bgart_surface.x = settings.pos.x;
            bgart_surface.y = settings.pos.y;
            bgart = bgart_surface.add_artwork("snap", 0, 0, settings.dimensions.w, settings.dimensions.h);
        }

        if (settings.show_wheel == "Enabled")
        {
            wheel_shadow = fe.add_image(settings.wheel_shadow_image, settings.wheel_shadow_pos.x, settings.wheel_shadow_pos.y, settings.wheel_shadow_dimensions.w, settings.wheel_shadow_dimensions.h);
            wheel_shadow.alpha = 255;

            wheel_dropshadow = PreserveArt("wheel", settings.wheel_pos.x, settings.wheel_pos.y, settings.wheel_dimensions.w, settings.wheel_dimensions.h);
            wheel_dropshadow.set_fit_or_fill("fit");
            wheel_dropshadow.art.set_rgb(0, 0, 0);
            wheel_dropshadow.alpha = 178;

            wheel_art = PreserveArt("wheel", settings.wheel_pos.x - settings.wheel_pos_offset.x, settings.wheel_pos.y - settings.wheel_pos_offset.y, settings.wheel_dimensions.w, settings.wheel_dimensions.h);
            wheel_art.set_fit_or_fill("fit");
        }
    }

    function update(ttype, var, ttime)
    {
        if (ttype == Transition.ToNewList || ttype == Transition.FromOldSelection)
        {
            if (settings.show_wheel == "Enabled")
            {
                local wheel_system = (fe.game_info(Info.System) == "") ? "Arcade" : fe.game_info(Info.System);
                local wheel_image = (fe.get_art("wheel") == "") ? "images/systems/" + wheel_system + ".png" : fe.get_art("wheel")
                wheel_dropshadow.file_name = wheel_image;
                wheel_art.file_name = wheel_image;
            }

            if (settings.crt_shader == "Disabled")
            {
                bgart.art.file_name = fe.get_art("snap");

                if (bgart.art.file_name == "")
                {
                    bgart.file_name = "images/static.mp4";
                    bgart.set_fit_or_fill("fill");
                    bgart.visible = true;
                    bgartmask_vert.visible = false;
                    bgartmask_horiz.visible = true;
                }
                else
                {
                    bgart.visible = true;
                    switch (fe.game_info(Info.Rotation).tostring())
                    {
                        case "90":
                        case "270":
                            bgart.set_fit_or_fill(settings.preserve_vert);
                            bgartmask_vert.set_fit_or_fill(settings.preserve_vert);
                            bgartmask_vert.visible = true;
                            bgartmask_horiz.visible = false;
                            break;
                        case "0":
                        case "180":
                        default:
                            bgart.set_fit_or_fill(settings.preserve_horiz);
                            bgartmask_horiz.set_fit_or_fill(settings.preserve_horiz);
                            bgartmask_horiz.visible = true;
                            bgartmask_vert.visible = false;
                            break;
                    }
                    if (fe.game_info(Info.DisplayType) == "vector")
                    {
                        bgartmask_horiz.visible = false;
                        bgartmask_vert.visible = false;
                    }
                }
            }
            else
            {
                bgart.file_name = fe.get_art("snap");
                local shader_res_width = 0;
                local shader_res_height = 0;

                if (bgart.file_name == "")
                {
                    bgart.file_name = "images/static.mp4";
                    shader_res_width = bgart.texture_width;
                    shader_res_height = bgart.texture_height;
                }
                else
                {
                    shader_res_width = bgart.texture_width;
                    shader_res_height = bgart.texture_height;

                    // 320x192 doubled = 245760
                    if (shader_res_width * shader_res_height >= 245760)
                    {
                        shader_res_width = shader_res_width / 2
                        shader_res_height = shader_res_height / 2
                    }
                }
                bgart_surface.visible = true;
                bgart.visible = true;
                switch (fe.game_info(Info.Rotation).tostring())
                {
                    case "90":
                    case "270":
                        shader_crt.set_param("vert", 1.0);
                        if (settings.preserve_vert == "fill")
                        {
                            set_surface_image_fill(bgart_surface, bgart, settings.dimensions);
                        }
                        else
                        {
                            set_surface_image_fit(bgart_surface, bgart, settings.dimensions);
                        }
                        break;
                    case "0":
                    case "180":
                    default:
                        shader_crt.set_param("vert", 0.0);
                        if (settings.preserve_horiz == "fill")
                        {
                            set_surface_image_fill(bgart_surface, bgart, settings.dimensions);
                        }
                        else
                        {
                            set_surface_image_fit(bgart_surface, bgart, settings.dimensions);
                        }
                        break;
                }
                if (fe.game_info(Info.DisplayType) == "vector")
                {
                    bgart_surface.shader = shader_bloom;
                }
                else
                {
                    if (settings.layout_rotation == RotateScreen.Left || settings.layout_rotation == RotateScreen.Right)
                    {
                        shader_crt.set_param("rotated", 1.0);
                    }
                    else
                    {
                        shader_crt.set_param("rotated", 0.0);
                    }
                    shader_crt.set_param("color_texture_pow2_sz", shader_res_width, shader_res_height);
                    bgart_surface.shader = shader_crt;
                }
                bgart_surface.x = settings.pos.x + ((settings.dimensions.w - bgart_surface.width) / 2);
                bgart_surface.y = (settings.dimensions.h - bgart_surface.height) / 2;
            }
        }
    }
}