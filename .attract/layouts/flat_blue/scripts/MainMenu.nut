/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

MainMenu class

*/

/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

MainMenu class

*/

class MainMenuPanel
{
    label = null;
    icon = null;
    action_type = null;
    action_value = null;

    constructor(label_str, icon_str, action_type_str, action_value_str)
    {
        label = label_str;
        icon = icon_str;
        action_type = action_type_str;
        action_value = action_value_str;
    }
}

class MainMenu
{
    panel_data = null;
    panels = null;
    base_surface = null;
    base_surface_bg = null;
    menu_surface = null;
    menu_surface_bg = null;
    menu_label_icon = null;
    menu_label_text = null;
    panel_surface = null;
    panel_text = null;
    panel_icon = null;

    selected_index = null;
    last_input_tick = null;
    menu_button_down = null;

    posy_offset = null;
    selected_bg = null;

    current_button = null;
    button_down = null;

    gameinfo_viewer = null;

    settings = null;

    constructor(layout_settings)
    {
        settings = layout_settings.mainmenu;
        selected_index = 0;

        panel_data = settings.panels;
        panels = [];

        base_surface = ::fe.add_surface(settings.surface_dimensions.w, settings.surface_dimensions.h);
        base_surface.set_pos(settings.surface_pos.x, settings.surface_pos.y);
        base_surface.visible = false;

        last_input_tick = 0;
        menu_button_down = false;
        current_button = "";

        gameinfo_viewer = MAMEInfoViewer(layout_settings);

        draw();

        fe.add_ticks_callback(this, "on_tick");
    }

    function draw()
    {
        base_surface_bg = base_surface.add_image("images/pixel.png", settings.surface_pos.x, settings.surface_pos.y, settings.surface_dimensions.w, settings.surface_dimensions.h);
        base_surface_bg.alpha = 217;
        base_surface_bg.set_rgb(0, 78, 114);

        menu_surface = base_surface.add_surface(settings.menu_surface_dimensions.w, settings.menu_surface_dimensions.h);
        menu_surface.set_pos(settings.menu_surface_pos.x, settings.menu_surface_pos.y);
        menu_surface_bg = menu_surface.add_image("images/pixel.png", 0, 0, settings.menu_surface_dimensions.w, settings.menu_surface_dimensions.h);
        menu_surface_bg.set_rgb(4, 41, 60);

        menu_surface.add_image("images/pixel.png", 0, 0, settings.menu_label_bg_dimensions.w, settings.menu_label_bg_dimensions.h);
        menu_label_icon = menu_surface.add_image(settings.menu_label_icon_image, settings.menu_label_icon_pos.x, settings.menu_label_icon_pos.y, settings.menu_label_icon_dimensions.w, settings.menu_label_icon_dimensions.h);
        menu_label_icon.set_rgb(6, 77, 118);

        // menu_label_text = menu_surface.add_text(settings.menu_label_text, settings.menu_label_text_pos.x, settings.menu_label_text_pos.y, settings.menu_label_text_dimensions.w, settings.menu_label_text_dimensions.h);
        menu_label_text = menu_surface.add_text(settings.menu_label_text, settings.menu_label_text_pos.x, settings.menu_label_text_pos.y, settings.menu_label_text_dimensions.w, settings.menu_label_text_dimensions.h);
        menu_label_text.set_rgb(6, 77, 118);
        menu_label_text.charsize = settings.menu_label_text_charsize;
        menu_label_text.font = settings.menu_label_text_font;
        menu_label_text.align = settings.menu_label_text_align;
        // menu_label_text.set_bg_rgb(255, 0, 0);

        posy_offset = null;
        selected_bg = null;

        selected_bg = menu_surface.add_image("images/pixel.png", 0, 0, settings.menu_label_bg_dimensions.w, settings.menu_label_bg_dimensions.h);
        selected_bg.set_rgb(2, 80, 116);

        foreach (idx, panel in panel_data)
        {
            posy_offset = settings.menu_label_bg_dimensions.h + (settings.menu_label_bg_dimensions.h * idx);

            // if (idx == selected_index)
            // {
            //     selected_bg = panel_surface.add_image("images/pixel.png", 0, posy_offset, settings.menu_label_bg_dimensions.w, settings.menu_label_bg_dimensions.h);
            //     selected_bg.set_rgb(2, 80, 116);
            // }

            // // fav
            // if (idx == 1)
            // {
            //     if (fe.game_info(Info.Favourite) == "1")
            //     {
            //         panel.icon = settings.fav_icon_remove;
            //         panel.label = settings.fav_label_remove;
            //     }
            //     else
            //     {
            //         panel.icon = settings.fav_icon_add;
            //         panel.label = settings.fav_label_add;
            //     }
            // }

            panel_surface = menu_surface.add_surface(settings.menu_label_bg_dimensions.w, settings.menu_label_bg_dimensions.h)
            panel_surface.set_pos(0, posy_offset);

            panel_icon = panel_surface.add_image(panel.icon, settings.menu_label_icon_pos.x, settings.menu_label_icon_pos.y, settings.menu_label_icon_dimensions.w, settings.menu_label_icon_dimensions.h);
            panel_text = panel_surface.add_text(panel.label, settings.menu_label_text_pos.x, settings.menu_label_text_pos.y, settings.menu_label_text_dimensions.w, settings.menu_label_text_dimensions.h);
            panel_text.charsize = settings.menu_label_text_charsize;
            panel_text.font = settings.menu_label_text_font;
            panel_text.align = settings.menu_label_text_align;

            local panel_table = 
            {
                text = panel_text,
                icon = panel_icon
            }

            panels.append(panel_table);
        }
    }

    function update_menu()
    {
        foreach (idx, panel in panel_data)
        {
            posy_offset = settings.menu_label_bg_dimensions.h + (settings.menu_label_bg_dimensions.h * idx);

            if (idx == selected_index)
            {
                selected_bg.y = posy_offset;
            }

            if (idx == 1)
            {
                if (fe.game_info(Info.Favourite) == "1")
                {
                    panel.icon = settings.fav_icon_remove;
                    panel.label = settings.fav_label_remove;
                }
                else
                {
                    panel.icon = settings.fav_icon_add;
                    panel.label = settings.fav_label_add;
                }
                panels[1].icon.file_name = panel.icon;
                panels[1].text.msg = panel.label;
            }
        }
    }

    function on_tick(ttime)
    {
        if (fe.get_input_state(settings.button))
        {
            if (menu_button_down == false)
            {
                if (base_surface.visible == false)
                {
                    show(true);
                }
                else
                {
                    show(false);
                }
                menu_button_down = true;
            }
        }
        else
        {
            menu_button_down = false;
        }

        if (current_button.len() > 0)
        {
            button_down = fe.get_input_state(current_button);
            if (!button_down)
            {
                current_button = "";
            }
            else if (ttime > last_input_tick + 80)
            {
                on_signal(current_button);
                last_input_tick = ttime;
            }

        }
    }

    function on_signal(signal_str)
    {
        switch (signal_str)
        {
            case "up":
                on_up();
                return true;
                break;
            case "down":
                on_down();
                return true;
                break;
            case "select":
                on_select();
                return true;
                break;
            default:
                return true;
                break;
        }
    }

    function show(flag)
    {
        if (flag)
        {
            fe.add_signal_handler(this, "on_signal");
            on_show();
        }
        else
        {
            fe.remove_signal_handler(this, "on_signal");
            on_hide();
        }
    }

    function on_up()
    {
        if (selected_index > 0)
        {
            selected_index --;
            update_menu();
        }
    }

    function on_down()
    {
        if (selected_index < (panels.len() - 1))
        {
            selected_index ++;
            update_menu();
        }
    }

    function on_select()
    {
        show(false);
        local action_type = panel_data[selected_index].action_type;
        local action_value = panel_data[selected_index].action_value;
        switch (action_type)
        {
            case "menu":
                on_menu(action_value);
                break;
            case "signal":
                fe.signal(action_value);
                break;
        }
    }

    function on_menu(action)
    {
        switch (action)
        {
            case "filters":
                break;
            case "systems":
                break;
            case "gameinfo":
                gameinfo_viewer.show(true);
                break;
        }
    }

    function on_show()
    {
        if (settings.remember_pos == "Disabled")
        {
            selected_index = 0;
        }
        update_menu();
        base_surface.visible = true;
    }

    function on_hide()
    {
        base_surface.visible = false;
    }
}
