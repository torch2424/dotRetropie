/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

InfoPanel class

*/

class InfoPanel
{
    settings = null;

    infopanel_filter_text_1 = null;
    infopanel_filter_text_2 = null;
    infopanel_game_text_1 = null;
    infopanel_game_text_2 = null;

    constructor(layout_settings)
    {
        settings = layout_settings.infopanel;

        draw();

        fe.add_transition_callback(this, "update");
    }

    function get_system_text() { return strip(fe.game_info(Info.System)); }
    function get_manufacturer_text() { return strip(fe.game_info(Info.Manufacturer)); }
    function get_year_text() { return strip(fe.game_info(Info.Year)); }
    function get_filter_text() { return strip(fe.filters[fe.list.filter_index].name); }
    function get_played_text() { return strip("Played " + fe.game_info(Info.PlayedCount) + " times"); }
    function get_romname_text() { return strip(fe.game_info(Info.Name)); }

    function draw()
    {
        if (settings.shadow_image != null)
        {
            local infopanel_shadow = fe.add_image(settings.shadow_image, settings.shadow_pos.x, settings.shadow_pos.y, settings.shadow_dimensions.w, settings.shadow_dimensions.h);
            infopanel_shadow.alpha = settings.shadow_strength;
        }
        if (settings.filter_shadow_image != null)
        {
            local filter_shadow = fe.add_image(settings.filter_shadow_image, settings.filter_shadow_pos.x, settings.filter_shadow_pos.y, settings.filter_shadow_dimensions.w, settings.filter_shadow_dimensions.h);
            filter_shadow.alpha = settings.shadow_strength;
        }
        if (settings.game_shadow_image != null)
        {
            local game_shadow = fe.add_image(settings.game_shadow_image, settings.game_shadow_pos.x, settings.game_shadow_pos.y, settings.game_shadow_dimensions.w, settings.game_shadow_dimensions.h);
            game_shadow.alpha = settings.shadow_strength;
        }


        fe.add_image(settings.filter_image, settings.filter_pos.x, settings.filter_pos.y, settings.filter_dimensions.w, settings.filter_dimensions.h);
        fe.add_image(settings.game_image, settings.game_pos.x, settings.game_pos.y, settings.game_dimensions.w, settings.game_dimensions.h);

        local infopanel_filter_text_line_height = settings.filter_text_dimensions.h / 2;

        infopanel_filter_text_1 = fe.add_text("", settings.filter_text_pos.x, settings.filter_text_pos.y, settings.filter_text_dimensions.w, infopanel_filter_text_line_height);
        infopanel_filter_text_1.charsize = settings.filter_text_charsize;
        infopanel_filter_text_1.font = settings.filter_text_font;
        infopanel_filter_text_1.align = settings.filter_text_align;

        infopanel_filter_text_2 = fe.add_text("", settings.filter_text_pos.x, settings.filter_text_pos.y + infopanel_filter_text_line_height, settings.filter_text_dimensions.w, infopanel_filter_text_line_height);
        infopanel_filter_text_2.charsize = settings.filter_text_charsize;
        infopanel_filter_text_2.font = settings.filter_text_font;
        infopanel_filter_text_2.align = settings.filter_text_align;

        local infopanel_game_text_line_height = settings.game_text_dimensions.h / 2;

        infopanel_game_text_1 = fe.add_text("", settings.game_text_pos.x, settings.game_text_pos.y, settings.game_text_dimensions.w, infopanel_game_text_line_height);
        infopanel_game_text_1.charsize = settings.game_text_charsize;
        infopanel_game_text_1.font = settings.game_text_font;
        infopanel_game_text_1.align = settings.game_text_align;

        infopanel_game_text_2 = fe.add_text("", settings.game_text_pos.x, settings.game_text_pos.y + infopanel_game_text_line_height, settings.game_text_dimensions.w, infopanel_game_text_line_height);
        infopanel_game_text_2.charsize = settings.game_text_charsize;
        infopanel_game_text_2.font = settings.game_text_font;
        infopanel_game_text_2.align = settings.game_text_align;
    }

    function update(ttype, var, ttime)
    {
        if (ttype == Transition.ToNewList || ttype == Transition.FromOldSelection)
        {
            local text_max_width = settings.game_text_dimensions.w;

            infopanel_filter_text_1.msg = get_system_text();
            truncate_message(infopanel_filter_text_1, text_max_width - settings.filter_text_width_offset);

            infopanel_filter_text_2.msg = get_filter_text();
            truncate_message(infopanel_filter_text_2, text_max_width - settings.filter_text_width_offset);

            switch (settings.game_info_1)
            {
                case "ROM Name":
                    infopanel_game_text_1.msg = get_romname_text();
                    break;
                case "Year":
                default:
                    infopanel_game_text_1.msg = get_year_text();
                    break;
            }
            truncate_message(infopanel_game_text_1, text_max_width - settings.game_text_width_offset);

            switch (settings.game_info_2)
            {
                case "Played Count":
                    infopanel_game_text_2.msg = get_played_text();
                    break;
                case "Manufacturer":
                default:
                    infopanel_game_text_2.msg = get_manufacturer_text();
                    break;
            }
            truncate_message(infopanel_game_text_2, text_max_width - settings.game_text_width_offset);
        }
    }
}
