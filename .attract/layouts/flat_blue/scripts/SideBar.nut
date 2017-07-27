/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

SideBarMenuPanel class
SideBarMenu class

*/

class SideBarMenuPanel
{
    settings = null;

    posy_offset = null;
    posy = null;
    artwork = null;
    artwork_mask = null;
    label = null;

    constructor(sidebar_settings)
    {
        settings = sidebar_settings;
    }

    function get_panel_text(index_offset)
    {
        local msg = "";
        local arr = null;
        if (fe.game_info(Info.CloneOf, index_offset) == "")
        {
            arr = split(fe.game_info(Info.Title, index_offset), "(/[");
            if (arr.len() > 0) return strip(arr[0]);
        }
        else
        {
            arr = split(fe.game_info(Info.Title, index_offset), "(");
            if (arr.len() > 0)
            {
                msg = strip(arr[0]);
                for (local i = 1; i < arr.len(); i++)
                {
                    msg += " (" + rstrip(arr[i]);
                }
            }
            arr = split(msg, "[");
            if (arr.len() > 0)
            {
                msg = strip(arr[0]);
                for (local i = 1; i < arr.len(); i++)
                {
                    msg += " [" + rstrip(arr[i]);
                }
            }
        }
        return msg;
    }

    function panel_text(index_offset)
    {
        local panel_text_tmp = fe.add_text("", 0, 0, 0, 50);
        panel_text_tmp.visible = false;

        panel_text_tmp.msg = get_panel_text(index_offset);

        panel_text_tmp.width = settings.panel_text_dimensions.w * 5;
        panel_text_tmp.charsize = settings.panel_text_charsize;
        panel_text_tmp.font = settings.panel_text_font;
        panel_text_tmp.align = settings.panel_text_align;

        local mult = (settings.lowres) ? 10 : 8

        truncate_message(panel_text_tmp, panel_text_tmp.width - ((settings.panel_text_width_offset * 2) * mult));

        local msg = panel_text_tmp.msg;
        panel_text_tmp = null;

        return msg;
    }

    function panel_selected_text(index_offset)
    {
        local panel_text_tmp = fe.add_text("", 0, 0, 0, 50);
        panel_text_tmp.visible = false;

        panel_text_tmp.msg = get_panel_text(index_offset);

        panel_text_tmp.width = settings.panel_selected_text_dimensions.w * 5;
        panel_text_tmp.charsize = settings.panel_selected_text_charsize;
        panel_text_tmp.font = settings.panel_selected_text_font;
        panel_text_tmp.align = settings.panel_selected_text_align;

        local mult = (settings.lowres) ? 10 : 8

        truncate_message(panel_text_tmp, panel_text_tmp.width - ((settings.panel_selected_text_width_offset * 2) * mult));

        local msg = panel_text_tmp.msg;
        panel_text_tmp = null;

        return msg;
    }

    function draw_panel(idx)
    {
        local posy_offset = (idx - settings.panel_selected_index < 0) ? 0 : settings.panel_selected_dimensions.h - settings.panel_dimensions.h;
        local posy = (settings.panel_dimensions.h * idx) + posy_offset;

        fe.add_image(settings.panel_image, settings.panel_posx, posy, settings.panel_dimensions.w, settings.panel_dimensions.h);
        fe.add_image(settings.panel_separator_image, settings.panel_separator_posx, posy, settings.panel_separator_dimensions.w, settings.panel_separator_dimensions.h);

        artwork = PreserveArt(settings.menu_art_type.tolower(), settings.panel_artwork_posx, posy + settings.panel_artwork_posy_offset, settings.panel_artwork_dimensions.w, settings.panel_artwork_dimensions.h);
        artwork.art.video_flags = (settings.menu_video == "Enabled") ? Vid.NoAudio : Vid.ImagesOnly;
        artwork.set_fit_or_fill("fill");
        artwork.index_offset = idx - settings.panel_selected_index;

        local mask = (fe.game_info(Info.Favourite, idx - settings.panel_selected_index) == "1") ? settings.panel_artwork_mask_favourite_image : settings.panel_artwork_mask_image;
        artwork_mask = fe.add_image(mask, settings.panel_artwork_mask_posx, posy + settings.panel_artwork_mask_posy_offset, settings.panel_artwork_mask_dimensions.w, settings.panel_artwork_mask_dimensions.h)

        label = fe.add_text(panel_text(idx - settings.panel_selected_index), settings.panel_text_posx, posy + settings.panel_text_posy_offset, settings.panel_text_dimensions.w, settings.panel_text_dimensions.h);
        label.index_offset = idx - settings.panel_selected_index;
        label.charsize = settings.panel_text_charsize;
        label.font = settings.panel_text_font;
        label.align = settings.panel_text_align;
        label.word_wrap = settings.panel_text_word_wrap;
    }

    function update_panel(idx)
    {
        if (artwork.art.file_name == "") artwork.art.file_name = "images/static.mp4";

        local mask = (fe.game_info(Info.Favourite, idx - settings.panel_selected_index) == "1") ? settings.panel_artwork_mask_favourite_image : settings.panel_artwork_mask_image;
        artwork_mask.file_name = mask;
        label.msg = panel_text(idx - settings.panel_selected_index);
    }

    function draw_selected(idx)
    {
        local posy = settings.panel_dimensions.h * settings.panel_selected_index;

        fe.add_image(settings.panel_selected_image, settings.panel_selected_posx, posy, settings.panel_selected_dimensions.w, settings.panel_selected_dimensions.h);

        artwork = PreserveArt(settings.menu_art_type.tolower(), settings.panel_selected_artwork_posx, posy + settings.panel_selected_artwork_posy_offset, settings.panel_selected_artwork_dimensions.w, settings.panel_selected_artwork_dimensions.h);
        artwork.art.video_flags = (settings.menu_video == "Enabled") ? Vid.NoAudio : Vid.ImagesOnly;
        artwork.set_fit_or_fill("fill");

        local mask = (fe.game_info(Info.Favourite) == "1") ? settings.panel_selected_artwork_mask_favourite_image : settings.panel_selected_artwork_mask_image;
        artwork_mask = fe.add_image(mask, settings.panel_selected_artwork_mask_posx, posy + settings.panel_selected_artwork_mask_posy_offset, settings.panel_selected_artwork_mask_dimensions.w, settings.panel_selected_artwork_mask_dimensions.h);

        fe.add_image(settings.panel_selected_arrow_image, settings.panel_selected_arrow_posx, posy, settings.panel_selected_arrow_dimensions.w, settings.panel_selected_arrow_dimensions.h);

        label = fe.add_text(panel_selected_text(idx - settings.panel_selected_index), settings.panel_selected_text_posx, posy + settings.panel_selected_text_posy_offset, settings.panel_selected_text_dimensions.w, settings.panel_selected_text_dimensions.h);
        label.charsize = settings.panel_selected_text_charsize;
        label.font = settings.panel_selected_text_font;
        label.align = settings.panel_selected_text_align;
        label.word_wrap = settings.panel_selected_text_word_wrap;
    }

    function update_selected(idx)
    {
        if (artwork.art.file_name == "") artwork.art.file_name = "images/static.mp4";

        local mask = (fe.game_info(Info.Favourite) == "1") ? settings.panel_selected_artwork_mask_favourite_image : settings.panel_selected_artwork_mask_image;
        artwork_mask.file_name = mask;
        label.msg = panel_selected_text(idx - settings.panel_selected_index);
    }
}

class SideBarMenu
{
    settings = null;

    sidebar_shadow = null;
    panels = [];


    constructor(layout_settings)
    {
        settings = layout_settings.sidebar;

        for (local i = 0; i < settings.numpanels; i++ )
        {
            create_panel();
        }

        draw();

        fe.add_transition_callback(this, "update");
    }

    function create_panel()
    {
        local panel = SideBarMenuPanel(settings);
        panels.append(panel);
    }

    function draw()
    {
        sidebar_shadow = fe.add_image(settings.shadow_image, settings.shadow_pos.x, settings.shadow_pos.y, settings.shadow_dimensions.w, settings.shadow_dimensions.h)
        sidebar_shadow.alpha = settings.shadow_strength;

        foreach (idx, item in panels)
        {
            if (idx == settings.panel_selected_index)
            {
                item.draw_selected(idx);
            }
            else
            {
                item.draw_panel(idx);
            }
        }
    }

    function draw_selected()
    {
        foreach (idx, item in panels)
        {
            if (idx == settings.panel_selected_index)
            {
                item.draw_selected(idx);
            }
        }
    }

    function update(ttype, var, ttime)
    {
        if (ttype == Transition.ToNewList || ttype == Transition.FromOldSelection)
        {
            foreach (idx, item in panels)
            {
                if (idx == settings.panel_selected_index)
                {
                    item.update_selected(idx);
                }
                else
                {
                    item.update_panel(idx);
                }
            }
        }
    }
}
