/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

MAMEDatViewer class

based on History.dat plugin

*/

class MAMEDatViewer
{
    m_up = false;
    m_block = false;
    m_curr_scroll_button = "";
    m_last_scroll_tick = 0;

    dat_path = null;
    idx_path = null;
    tag = null;

    surf = null;
    surf_art = null;
    m_text = null;
    m_curr_rom = null;
    next_ln_overflow = null;
    loaded_idx = null;

    // sidebar = SideBarMenu(layout.settings);

    settings = null;

    constructor(layout_settings)
    {
        fe.add_ticks_callback(this, "on_tick");

        settings = layout_settings.mamedats;

        next_ln_overflow=""; // used by the get_next_ln() function
        loaded_idx = {};
        m_curr_rom = "";

        draw();
    }

    function draw()
    {
        surf = fe.add_surface(settings.surface_dimensions.w, settings.surface_dimensions.h);
        surf.set_pos(settings.surface_pos.x, settings.surface_pos.y);
        local surf_bg = surf.add_image(settings.bg_image, settings.bg_pos.x, settings.bg_pos.y, settings.bg_dimensions.w, settings.bg_dimensions.h);
        surf_bg.set_rgb(0, 0, 0);
        surf_bg.alpha = 220;

        m_text = surf.add_text( "", settings.text_pos.x, settings.text_pos.y, settings.text_dimensions.w, settings.text_dimensions.h);
        m_text.first_line_hint = 0; // enables word wrapping
        m_text.charsize = settings.text_charsize;
        m_text.align = Align.Left;
        m_text.font = settings.text_font;

        // sidebar.draw_selected();

        surf.visible=false;
    }

    function on_tick( ttime )
    {
        if ( m_curr_scroll_button.len() > 0 )
        {
            local nav_down = fe.get_input_state( m_curr_scroll_button );
            if ( !nav_down )
                m_curr_scroll_button = "";
            else if ( ttime > m_last_scroll_tick + 80 )
            {
                on_signal( m_curr_scroll_button );
                m_last_scroll_tick = ttime;
            }
        }
    }

    function on_signal(signal)
    {
        if (signal == "up")
        {
            on_scroll_up();
            m_curr_scroll_button = signal;
            return true;
        }
        else if (signal == "down")
        {
            on_scroll_down();
            m_curr_scroll_button = signal;
            return true;
        }
        else if (signal == "select")
        {
            on_select();
            return true;
        }
        else if ((signal == "exit_no_menu") || (signal == "exit"))
        {
            show(false);
            return true;
        }
        else if ((signal == "page_up") || (signal == "prev_letter"))
        {
            on_page_up();
            m_curr_scroll_button = signal;
            return true;
        }
        else if ((signal == "page_down") || (signal == "next_letter"))
        {
            on_page_down();
            m_curr_scroll_button = signal;
            return true;
        }
        else
        {
            return true;
        }
    }

    function show(flag)
    {
        if (flag)
        {
            m_up = true;
            fe.add_signal_handler(this, "on_signal");
            on_show();
        }
        else
        {
            m_up = false;
            fe.remove_signal_handler(this, "on_signal");
            on_hide();
        }
    }

    function on_show()
    {
        local sys = split( fe.game_info( Info.System ), ";" );
        local rom = fe.game_info( Info.Name );

        //
        // we only go to the trouble of loading the entry if
        // it is not already currently loaded
        //
        if ( m_curr_rom != rom )
        {
            m_curr_rom = rom;
            local alt = fe.game_info( Info.AltRomname );
            local cloneof = fe.game_info( Info.CloneOf );

            local lookup = get_offset(sys, rom, alt, cloneof);

            if ( lookup >= 0 )
            {
                m_text.first_line_hint = 0;
                m_text.msg = get_entry(lookup);
            }
            else
            {
                if ( lookup == -2 )
                    m_text.msg = "Index file not found.  Try generating an index from the history.dat plug-in configuration menu.";
                else    
                    m_text.msg = "Unable to locate: "
                        + rom;
            }
        }

        surf.visible = true;
    }

    function on_hide()
    {
        surf.visible = false;
    }

    function on_scroll_up()
    {
        m_text.first_line_hint--;
    }

    function on_page_up()
    {
        m_text.first_line_hint -= 12;
    }

    function on_scroll_down()
    {
        m_text.first_line_hint++;
    }

    function on_page_down()
    {
        m_text.first_line_hint += 12;
    }

    function on_select()
    {
        show(false);
    }

    //
    // Return the text for the history.dat entry after the given offset
    //
    function get_entry(offset)
    {
        local datfile;
        datfile = file(fe.path_expand(dat_path), "rb");
        datfile.seek( offset );

        local entry = "\n\n"; // a bit of space to start
        local open_entry = false;

        while ( !datfile.eos() )
        {
            local blb = datfile.readblob( READ_BLOCK_SIZE );
            while ( !blb.eos() )
            {
                local line = get_next_ln( blb );

                if ( !open_entry )
                {
                    //
                    // forward to the $bio or $mame tag
                    //
                    if (( line.len() < 1 )
                            || (  line != tag ))
                        continue;

                    open_entry = true;
                }
                else
                {
                    if ( line == "$end" )
                    {
                        entry += "\n\n";
                        return entry;
                    }
                    else if (!(blb.eos() && (line == "" ))) entry += line + "\n";
                }
            }
        }
        return entry;
    }

    //
    // Load the index for the given system if it is not already loaded
    //
    function load_index(sys)
    {
        // check if system index already loaded
        //
        if (loaded_idx.rawin(sys)) return true;

        local idx;
        try
        {
            idx = file(idx_path + sys + ".idx", "r");
        }
        catch(e)
        {
            loaded_idx[sys] <- null;
            return false;
        }

        loaded_idx[sys] <- {};

        while (!idx.eos())
        {
            local blb = idx.readblob(READ_BLOCK_SIZE);
            while (!blb.eos())
            {
                local line = get_next_ln(blb);
                local bits = split(line, ";");
                if (bits.len() > 0) (loaded_idx[sys])[bits[0]] <- bits[1].tointeger();
            }
        }
        return true;
    }

    //
    // Return the index the history.dat entry for the specified system and rom
    //
    function get_offset(sys, rom, alt, cloneof)
    {
        foreach (s in sys)
        {
            if ((load_index(s)) && (loaded_idx[s] != null))
            {
                if (loaded_idx[s].rawin(rom)) return (loaded_idx[s])[rom];
                else if ((alt.len() > 0) && (loaded_idx[s].rawin(alt))) return (loaded_idx[s])[alt];
                else if ((cloneof.len() > 0) && (loaded_idx[s].rawin(cloneof))) return (loaded_idx[s])[cloneof];
            }
        }
        if ((sys.len() != 1) || (sys[0] != "info")) return get_offset(["info"], rom, alt, cloneof);
        return -1;
    }
}

class HistoryViewer extends MAMEDatViewer
{
    constructor(layout_settings)
    {
        base.constructor(layout_settings)
        dat_path = settings.historydat_path;
        idx_path = FeConfigDirectory + "history.idx/";
        tag = "$bio";
    }
}

class MAMEInfoViewer extends MAMEDatViewer
{
    constructor(layout_settings)
    {
        base.constructor(layout_settings)
        dat_path = settings.mameinfodat_path;
        idx_path = FeConfigDirectory + "mameinfo.idx/";
        tag = "$mame";
    }
}
