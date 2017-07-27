/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

LayoutSettings class

Public Methods:
    initialize()
        Sets the layout rotation, aspect ratio, and dimensions based on the UserConfig layout_rotation value.
        Use this before drawing to set up the base settings for the layout.

    set_layout_dimensions(scalar2)
        Set the layout width and height, aspect ratio, and lowres flag.
        Use this prior to calling initialize() if you want to manually set the layout dimensions
        (useful for testing various layout aspect ratios and dimensions during development).

    set_user_config(string, string|int|float|bool)
        Set the value of an item from the UserConfig class.

    get_user_config(string)
        Get the value of an item from the UserConfig class.
        returns string|int|float|bool

    get_lowres_flag()
        Get the value of the lowres flag that is set at initialization.
        returns bool

    get_layout_rotation()
        Get the value of the layout rotation setting.
        returns Rotation enum type

    get_layout_rotation_name()
        Get the value of the layout rotation setting as a string.
        returns string

    get_layout_width()
        Get the value of the layout width.
        returns int

    get_layout_height()
        Get the value of the layout height.
        returns int

    get_layout_dimensions()
        Get the value of the layout width and height.
        returns scalar2()

    get_layout_aspect_ratio_float()
        Get the value of the layout aspect ratio as a float.
        returns float

    get_layout_aspect_ratio_width()
        Get the value of the layout aspect ratio width.
        returns int

    get_layout_aspect_ratio_height()
        Get the value of the layout aspect ratio height.
        returns int

    get_layout_aspect_ratio_dimensions()
        Get the value of the layout aspect ratio width and height.
        returns scalar2()

    get_layout_aspect_ratio_gcd()
        Get the value of the layout aspect ratio greatest common divisor (gcd).
        returns int

    get_layout_aspect_ratio_name()
        get the value of the layout aspect ratio width and height as a string.
        returns string

    init_layout_settings()
        populate the layout.settings table with position and size variables for the current aspect ratio.
        these variables are then used by the Background, SideBar, and InfoPanel classes.

    function convert_scalar2(scalar2)
        convert the x,y / h,w values of a scalar2 to scale up/down to suit the current video resolution.
        returns scalar2()

    function convert_width(int)
        convert a width (or x) value to scale up/down to suit the current video resolution.
        returns int

    function convert_height(int)
        convert a height (or y) value to scale up/down to suit the current video resolution.
        returns int

*/

class LayoutSettings
{
    _user_config = null;
    _lowres = null;
    _rotation = null;
    _layout_dimensions = null;
    _aspect_ratio_float = null;
    _aspect_ratio_gcd = null;
    _aspect_ratio_dimensions = null;

    settings = null;

    constructor()
    {
        settings = {};

        _layout_dimensions = scalar2(fe.layout.width, fe.layout.height);
        _aspect_ratio_dimensions = scalar2();
        _init_user_config();
    }

    // initialization functions
    function _init_user_config() { _user_config = fe.get_config(); }

    // internal functions
    function _set_lowres_flag() { _lowres = (get_layout_width() * get_layout_height() < 786432) ? true : false; } // 1024 * 768 = 786432 pixels
    function _set_layout_aspect_ratio()
    {
        _aspect_ratio_float = get_aspect_ratio_float(get_layout_dimensions());
        _aspect_ratio_gcd = get_gcd(get_layout_dimensions());
        _aspect_ratio_dimensions = scalar2(get_aspect_ratio_dimensions(get_layout_dimensions()));
    }

    // public functions
    function get_layout_setting(key)
    {
        return settings[key];
    }

    function set_user_config(item, value) { if (_user_config[item] != null) _user_config[item] = value; }
    function get_user_config(item) { if (_user_config[item] != null) return _user_config[item]; }

    function get_lowres_flag() { return _lowres; }

    function get_layout_rotation() { return _rotation; }
    function get_layout_rotation_name()
    {
        local name = "";
        switch (get_layout_rotation())
        {
            case RotateScreen.None:
                name = "None"
                break;
            case RotateScreen.Right:
                name = "Right"
                break;
            case RotateScreen.Flip:
                name = "Flip"
                break;
            case RotateScreen.Left:
                name = "Left"
                break;
        }
        return name;
    }

    function set_layout_dimensions(dimensions)
    {
        _layout_dimensions.width = dimensions.width;
        fe.layout.width = get_layout_width();

        _layout_dimensions.height = dimensions.height;
        fe.layout.height = get_layout_height();

        _set_layout_aspect_ratio();
        _set_lowres_flag();
    }

    function get_layout_width() { return _layout_dimensions.width; }
    function get_layout_height() { return _layout_dimensions.height; }
    function get_layout_dimensions() { return _layout_dimensions; }

    function get_layout_aspect_ratio_float() { return _aspect_ratio_float; }
    function get_layout_aspect_ratio_width() { return _aspect_ratio_dimensions.width; }
    function get_layout_aspect_ratio_height() { return _aspect_ratio_dimensions.height; }
    function get_layout_aspect_ratio_dimensions() { return _aspect_ratio_dimensions; }
    function get_layout_aspect_ratio_gcd() { return _aspect_ratio_gcd; }
    function get_layout_aspect_ratio_name() { return get_layout_aspect_ratio_width() + ":" + get_layout_aspect_ratio_height() }

    function set_layout_rotation()
    {
        switch (get_user_config("layout_rotation"))
        {
            case "None":
                _rotation = RotateScreen.None;
                break;
            case "Right":
                _rotation = RotateScreen.Right;
                break;
            case "Flip":
                _rotation = RotateScreen.Flip;
                break;
            case "Left":
                _rotation = RotateScreen.Left;
                break;
        }
        fe.layout.base_rotation = get_layout_rotation();

        local dimensions = scalar2();
        switch (get_layout_rotation())
        {
            case RotateScreen.Right:
            case RotateScreen.Left:
                dimensions.width = get_layout_height();
                dimensions.height = get_layout_width();
                break;
            case RotateScreen.None:
            case RotateScreen.Flip:
            default:
                dimensions.width = get_layout_width();
                dimensions.height = get_layout_height();
                break;
        }
        set_layout_dimensions(dimensions);
    }

    function initialize()
    {
        set_layout_rotation();
        init_layout_settings();

        log(format("layout width:    %d", get_layout_width()));
        log(format("layout height:   %d", get_layout_height()));
        log(format("aspect ratio:    %d:%d (%f:1)", get_layout_aspect_ratio_width(), get_layout_aspect_ratio_height(), get_layout_aspect_ratio_float()));
        log(format("layout rotation: %s", get_layout_rotation_name()));
        log(format("lowres:          %s", get_lowres_flag().tostring()));
    }

    function init_layout_settings()
    {
        settings.bg <- {}
        settings.sidebar <- {}
        settings.infopanel <- {}
        settings.overlaymenu <- {}
        settings.mainmenu <- {}
        settings.mamedats <- {}

        switch(get_layout_aspect_ratio_name())
        {
            case "3:4":
                settings.base_dimensions <- scalar2(1080, 1440);

                settings.bg.preserve_vert <- "fill";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(380, 205)) : convert_scalar2(scalar2(375, 159));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_dimensions.w / 2)), convert_height(250));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_vert.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1200, 1024));
                settings.bg.wheel_shadow_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_shadow_dimensions.w / 2)), -180);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 7 : 9;

                settings.infopanel.shadow_image <- null;
                settings.infopanel.shadow_dimensions <- null;
                settings.infopanel.shadow_pos <- null;

                settings.infopanel.filter_image <- "images/infopanel_filter_bg_vert.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_text_dimensions.w - convert_width(30), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- "images/infopanel_filter_bg_shadow_vert.png";
                settings.infopanel.filter_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.filter_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_shadow_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_shadow_dimensions.h);

                settings.infopanel.game_image <- "images/infopanel_game_bg_vert.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, 0);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_text_dimensions.w - convert_width(30), (settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2);

                settings.infopanel.game_shadow_image <- "images/infopanel_game_bg_shadow_vert.png";
                settings.infopanel.game_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.game_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_shadow_dimensions.w, 0);

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(27) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(22);

                settings.mamedats.text_lines <- (get_lowres_flag()) ? 40 : 40;
                break;

            case "4:3":
                settings.base_dimensions <- scalar2(1440, 1080);

                settings.bg.preserve_vert <- (get_lowres_flag() && get_user_config("scanline_strength") != "None") ? "fill" : "fit";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(380, 215)) : convert_scalar2(scalar2(385, 154));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(convert_width(settings.base_dimensions.w) - (settings.bg.wheel_dimensions.w + convert_width(50)), convert_height(65));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_horiz.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1170, 630));
                settings.bg.wheel_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.bg.wheel_shadow_dimensions.w, 0);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 5 : 7;

                settings.infopanel.shadow_image <- "images/infopanel_shadow.png";
                settings.infopanel.shadow_dimensions <- convert_scalar2(scalar2(880, 248));
                settings.infopanel.shadow_pos <- scalar2(convert_scalar2(settings.base_dimensions) - settings.infopanel.shadow_dimensions)

                settings.infopanel.filter_image <- "images/infopanel_filter_bg.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(740, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(300, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(680), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- null;
                settings.infopanel.filter_shadow_dimensions <- null;
                settings.infopanel.filter_shadow_pos <- null;

                settings.infopanel.game_image <- "images/infopanel_game_bg.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(310), convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h + ((settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2));

                settings.infopanel.game_shadow_image <- null;
                settings.infopanel.game_shadow_dimensions <- null;
                settings.infopanel.game_shadow_pos <- null;

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(24) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(26) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(24) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(24) : convert_height(22);

                settings.mamedats.text_lines <- (get_lowres_flag()) ? 30 : 30;
                break;

            case "4:5":
                settings.base_dimensions <- scalar2(1080, 1350);

                settings.bg.preserve_vert <- "fill";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- convert_scalar2(scalar2(340, 149));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_dimensions.w / 2)), convert_height(250));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_vert.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1200, 1024));
                settings.bg.wheel_shadow_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_shadow_dimensions.w / 2)), -180);

                settings.sidebar.numpanels <- 9;

                settings.infopanel.shadow_image <- null;
                settings.infopanel.shadow_dimensions <- null;
                settings.infopanel.shadow_pos <- null;

                settings.infopanel.filter_image <- "images/infopanel_filter_bg_vert.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_text_dimensions.w - convert_width(30), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- "images/infopanel_filter_bg_shadow_vert.png";
                settings.infopanel.filter_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.filter_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_shadow_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_shadow_dimensions.h);

                settings.infopanel.game_image <- "images/infopanel_game_bg_vert.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, 0);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_text_dimensions.w - convert_width(30), (settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2);

                settings.infopanel.game_shadow_image <- "images/infopanel_game_bg_shadow_vert.png";
                settings.infopanel.game_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.game_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_shadow_dimensions.w, 0);

                settings.sidebar.panel_text_charsize <- convert_height(20);
                settings.sidebar.panel_selected_text_charsize <- convert_height(22);
                settings.infopanel.filter_text_charsize <- convert_height(22);
                settings.infopanel.game_text_charsize <- convert_height(22);

                settings.mamedats.text_lines <- 40;
                break;

            case "5:4":
                settings.base_dimensions <- scalar2(1350, 1080);

                settings.bg.preserve_vert <- "fit";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- convert_scalar2(scalar2(380, 154));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(convert_width(settings.base_dimensions.w) - (settings.bg.wheel_dimensions.w + convert_width(50)), convert_height(65));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_horiz.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1170, 630));
                settings.bg.wheel_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.bg.wheel_shadow_dimensions.w, 0);

                settings.sidebar.numpanels <- 7;

                settings.infopanel.shadow_image <- "images/infopanel_shadow.png";
                settings.infopanel.shadow_dimensions <- convert_scalar2(scalar2(880, 248));
                settings.infopanel.shadow_pos <- scalar2(convert_scalar2(settings.base_dimensions) - settings.infopanel.shadow_dimensions)

                settings.infopanel.filter_image <- "images/infopanel_filter_bg.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(740, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(300, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(680), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- null;
                settings.infopanel.filter_shadow_dimensions <- null;
                settings.infopanel.filter_shadow_pos <- null;

                settings.infopanel.game_image <- "images/infopanel_game_bg.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(310), convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h + ((settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2));

                settings.infopanel.game_shadow_image <- null;
                settings.infopanel.game_shadow_dimensions <- null;
                settings.infopanel.game_shadow_pos <- null;

                settings.sidebar.panel_text_charsize <- convert_height(20);
                settings.sidebar.panel_selected_text_charsize <- convert_height(22);
                settings.infopanel.filter_text_charsize <- convert_height(22);
                settings.infopanel.game_text_charsize <- convert_height(22);

                settings.mamedats.text_lines <- 30;
                break;

            case "3:5":
            case "5:8":
            case "10:16":
                settings.base_dimensions <- scalar2(1200, 1920);

                settings.bg.preserve_vert <- "fill";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(385, 213)) : convert_scalar2(scalar2(330, 174));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_dimensions.w / 2)), convert_height(250));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_vert.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1200, 1024));
                settings.bg.wheel_shadow_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_shadow_dimensions.w / 2)), -180);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 9 : 11;

                settings.infopanel.shadow_image <- "images/infopanel_shadow.png";
                settings.infopanel.shadow_dimensions <- convert_scalar2(scalar2(880, 248));
                settings.infopanel.shadow_pos <- scalar2(convert_scalar2(settings.base_dimensions) - settings.infopanel.shadow_dimensions)

                settings.infopanel.filter_image <- "images/infopanel_filter_bg.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(740, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(300, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(680), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- null;
                settings.infopanel.filter_shadow_dimensions <- null;
                settings.infopanel.filter_shadow_pos <- null;

                settings.infopanel.game_image <- "images/infopanel_game_bg.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(310), convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h + ((settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2));

                settings.infopanel.game_shadow_image <- null;
                settings.infopanel.game_shadow_dimensions <- null;
                settings.infopanel.game_shadow_pos <- null;

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(26) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(26) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(26) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(26) : convert_height(22);

                settings.mamedats.text_lines <- (get_lowres_flag()) ? 45 : 50;
                break;

            case "5:3":
            case "8:5":
            case "16:10":
                settings.base_dimensions <- scalar2(1920, 1200);

                settings.bg.preserve_vert <- "fit";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(380, 239)) : convert_scalar2(scalar2(320, 171));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(convert_width(settings.base_dimensions.w) - (settings.bg.wheel_dimensions.w + convert_width(50)), convert_height(65));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_horiz.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1170, 630));
                settings.bg.wheel_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.bg.wheel_shadow_dimensions.w, 0);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 5 : 7;

                settings.infopanel.shadow_image <- "images/infopanel_shadow.png";
                settings.infopanel.shadow_dimensions <- convert_scalar2(scalar2(880, 248));
                settings.infopanel.shadow_pos <- scalar2(convert_scalar2(settings.base_dimensions) - settings.infopanel.shadow_dimensions)

                settings.infopanel.filter_image <- "images/infopanel_filter_bg.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(740, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(300, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(680), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- null;
                settings.infopanel.filter_shadow_dimensions <- null;
                settings.infopanel.filter_shadow_pos <- null;

                settings.infopanel.game_image <- "images/infopanel_game_bg.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(310), convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h + ((settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2));

                settings.infopanel.game_shadow_image <- null;
                settings.infopanel.game_shadow_dimensions <- null;
                settings.infopanel.game_shadow_pos <- null;

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(32) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(27) : convert_height(22);

                settings.mamedats.text_lines <- (get_lowres_flag()) ? 30 : 35;
                break;

            case "384:683":
            case "48:85":
            case "9:16":
                settings.base_dimensions <- scalar2(1080, 1920);

                settings.bg.preserve_vert <- "fill";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(385, 213)) : convert_scalar2(scalar2(330, 174));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_dimensions.w / 2)), convert_height(250));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_vert.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1200, 1024));
                settings.bg.wheel_shadow_pos <- scalar2(settings.sidebar.panel_dimensions.w + (((convert_width(settings.base_dimensions.w) - settings.sidebar.panel_dimensions.w) / 2) - (settings.bg.wheel_shadow_dimensions.w / 2)), -180);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 9 : 11;

                settings.infopanel.shadow_image <- null;
                settings.infopanel.shadow_dimensions <- null;
                settings.infopanel.shadow_pos <- null;

                settings.infopanel.filter_image <- "images/infopanel_filter_bg_vert.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_text_dimensions.w - convert_width(30), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- "images/infopanel_filter_bg_shadow_vert.png";
                settings.infopanel.filter_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.filter_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_shadow_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_shadow_dimensions.h);

                settings.infopanel.game_image <- "images/infopanel_game_bg_vert.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, 0);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_text_dimensions.w - convert_width(30), (settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2);

                settings.infopanel.game_shadow_image <- "images/infopanel_game_bg_shadow_vert.png";
                settings.infopanel.game_shadow_dimensions <- convert_scalar2(scalar2(520, 248));
                settings.infopanel.game_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_shadow_dimensions.w, 0);

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(23) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(25) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(25) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(25) : convert_height(22);

                settings.mamedats.text_lines <- 50;
                break;

            case "683:384":
            case "85:48":
            case "16:9":
            default:
                settings.base_dimensions <- scalar2(1920, 1080);

                settings.bg.preserve_vert <- "fit";
                settings.bg.preserve_horiz <- "fill";

                settings.sidebar.panel_dimensions <- (get_lowres_flag()) ? convert_scalar2(scalar2(385, 215)) : convert_scalar2(scalar2(380, 154));

                settings.bg.wheel_dimensions <- convert_scalar2(scalar2(450, 240));
                settings.bg.wheel_pos <- scalar2(convert_width(settings.base_dimensions.w) - (settings.bg.wheel_dimensions.w + convert_width(50)), convert_height(65));

                settings.bg.wheel_shadow_image <- "images/wheel_shadow_horiz.png";
                settings.bg.wheel_shadow_dimensions <- convert_scalar2(scalar2(1170, 630));
                settings.bg.wheel_shadow_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.bg.wheel_shadow_dimensions.w, 0);

                settings.sidebar.numpanels <- (get_lowres_flag()) ? 5 : 7;

                settings.infopanel.shadow_image <- "images/infopanel_shadow.png";
                settings.infopanel.shadow_dimensions <- convert_scalar2(scalar2(880, 248));
                settings.infopanel.shadow_pos <- scalar2(convert_scalar2(settings.base_dimensions) - settings.infopanel.shadow_dimensions)

                settings.infopanel.filter_image <- "images/infopanel_filter_bg.png";
                settings.infopanel.filter_dimensions <- convert_scalar2(scalar2(740, 100));
                settings.infopanel.filter_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.filter_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h);
                settings.infopanel.filter_text_dimensions <- convert_scalar2(scalar2(300, 60));
                settings.infopanel.filter_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(680), convert_height(settings.base_dimensions.h) - settings.infopanel.filter_dimensions.h + ((settings.infopanel.filter_dimensions.h - settings.infopanel.filter_text_dimensions.h) / 2));

                settings.infopanel.filter_shadow_image <- null;
                settings.infopanel.filter_shadow_dimensions <- null;
                settings.infopanel.filter_shadow_pos <- null;

                settings.infopanel.game_image <- "images/infopanel_game_bg.png";
                settings.infopanel.game_dimensions <- convert_scalar2(scalar2(380, 100));
                settings.infopanel.game_pos <- scalar2(convert_width(settings.base_dimensions.w) - settings.infopanel.game_dimensions.w, convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h);
                settings.infopanel.game_text_dimensions <- convert_scalar2(scalar2(280, 60));
                settings.infopanel.game_text_pos <- scalar2(convert_width(settings.base_dimensions.w) - convert_width(310), convert_height(settings.base_dimensions.h) - settings.infopanel.game_dimensions.h + ((settings.infopanel.game_dimensions.h - settings.infopanel.game_text_dimensions.h) / 2));

                settings.infopanel.game_shadow_image <- null;
                settings.infopanel.game_shadow_dimensions <- null;
                settings.infopanel.game_shadow_pos <- null;

                settings.sidebar.panel_text_charsize <- (get_lowres_flag()) ? convert_height(23) : convert_height(20);
                settings.sidebar.panel_selected_text_charsize <-  (get_lowres_flag()) ? convert_height(25) : convert_height(22);
                settings.infopanel.filter_text_charsize <- (get_lowres_flag()) ? convert_height(25) : convert_height(22);
                settings.infopanel.game_text_charsize <- (get_lowres_flag()) ? convert_height(25) : convert_height(22);

                settings.mamedats.text_lines <- 30;
                break;
        }
        settings.bg.crt_shader <- get_user_config("crt_shader");
        settings.bg.show_wheel <- get_user_config("show_wheel");
        settings.bg.shadow_strength <- get_strength(get_user_config("shadow_strength"));
        settings.bg.scanline_strength <- get_strength(get_user_config("scanline_strength"));
        settings.bg.lowres <- get_lowres_flag();
        settings.bg.layout_rotation <- get_layout_rotation();

        settings.bg.image <- "images/background_light_grid.jpg";
        settings.bg.pos <- scalar2(settings.sidebar.panel_dimensions.w, 0);
        settings.bg.dimensions <- scalar2(convert_width(settings.base_dimensions.w) - settings.bg.pos.x, convert_height(settings.base_dimensions.h));
        settings.bg.pos.y = convert_height(settings.base_dimensions.h) - settings.bg.dimensions.h;
        settings.bg.wheel_pos_offset <- convert_scalar2(scalar2(10, 10));

        settings.sidebar.menu_art_type <- get_user_config("menu_art_type");
        settings.sidebar.menu_video <- get_user_config("menu_video");
        settings.sidebar.lowres <- get_lowres_flag();

        settings.sidebar.shadow_image <- "images/sidebar_shadow.png";
        settings.sidebar.shadow_pos <- scalar2(settings.bg.pos.x, 0);
        settings.sidebar.shadow_dimensions <- convert_scalar2(scalar2(200, settings.base_dimensions.h));
        settings.sidebar.shadow_strength <- get_strength(get_user_config("shadow_strength"));

        settings.sidebar.panel_image <- "images/panel_bg_1px.png";
        settings.sidebar.panel_posx <- 0;
        settings.sidebar.panel_separator_image <- "images/panel_bg_separator_1px.png"
        settings.sidebar.panel_separator_posx <- settings.sidebar.panel_posx;
        settings.sidebar.panel_separator_dimensions <- scalar2(settings.sidebar.panel_dimensions.w, 1);
        settings.sidebar.panel_artwork_dimensions <- convert_scalar2(scalar2(130, 0));
        settings.sidebar.panel_artwork_dimensions.y = settings.sidebar.panel_artwork_dimensions.x;
        settings.sidebar.panel_artwork_posx <- convert_width(18);
        settings.sidebar.panel_artwork_posy_offset <- round((settings.sidebar.panel_dimensions.h - settings.sidebar.panel_artwork_dimensions.h) / 2);
        settings.sidebar.panel_artwork_mask_image <- (get_lowres_flag()) ? "images/panel_artwork_mask_lowres.png" : "images/panel_artwork_mask.png";
        settings.sidebar.panel_artwork_mask_favourite_image <- (get_lowres_flag()) ? "images/panel_artwork_favourite_mask_lowres.png" : "images/panel_artwork_favourite_mask.png";
        settings.sidebar.panel_artwork_mask_posx <- settings.sidebar.panel_artwork_posx;
        settings.sidebar.panel_artwork_mask_posy_offset <- settings.sidebar.panel_artwork_posy_offset;
        settings.sidebar.panel_artwork_mask_dimensions <- scalar2(settings.sidebar.panel_artwork_dimensions.w, settings.sidebar.panel_artwork_dimensions.h);
        settings.sidebar.panel_text_posx <- convert_width(140);
        settings.sidebar.panel_text_dimensions <- scalar2(settings.sidebar.panel_dimensions.w - settings.sidebar.panel_text_posx + convert_width(10), settings.sidebar.panel_dimensions.h - convert_height(16));
        settings.sidebar.panel_text_posy_offset <- (settings.sidebar.panel_dimensions.h - settings.sidebar.panel_text_dimensions.h) / 2;
        settings.sidebar.panel_text_width_offset <- convert_width(22);
        settings.sidebar.panel_text_font <- "Lato-Medium.ttf";
        settings.sidebar.panel_text_align <- Align.Left;
        settings.sidebar.panel_text_word_wrap <- true;

        settings.sidebar.panel_selected_image <- "images/panel_selected_bg_1px.png";
        settings.sidebar.panel_selected_dimensions <- scalar2(settings.sidebar.panel_dimensions.w, convert_height(settings.base_dimensions.h) - (settings.sidebar.panel_dimensions.h * (settings.sidebar.numpanels - 1)));
        settings.sidebar.panel_selected_posx <- 0;
        settings.sidebar.panel_selected_arrow_image <- "images/panel_selected_arrow.png"
        settings.sidebar.panel_selected_arrow_posx <- settings.sidebar.panel_dimensions.w;
        settings.sidebar.panel_selected_arrow_dimensions <- scalar2((settings.sidebar.panel_selected_dimensions.h / 39) * 20, settings.sidebar.panel_selected_dimensions.h);
        settings.sidebar.panel_selected_artwork_posx <- convert_width(10);
        settings.sidebar.panel_selected_artwork_dimensions <- convert_scalar2(scalar2(146, 0));
        settings.sidebar.panel_selected_artwork_dimensions.y = settings.sidebar.panel_selected_artwork_dimensions.x;
        settings.sidebar.panel_selected_artwork_posy_offset <- round((settings.sidebar.panel_selected_dimensions.h - settings.sidebar.panel_selected_artwork_dimensions.h) / 2);
        settings.sidebar.panel_selected_artwork_mask_image <- (get_lowres_flag()) ? "images/panel_selected_artwork_mask_lowres.png" : "images/panel_selected_artwork_mask.png";
        settings.sidebar.panel_selected_artwork_mask_favourite_image <- (get_lowres_flag()) ? "images/panel_selected_artwork_favourite_mask_lowres.png" : "images/panel_selected_artwork_favourite_mask.png";
        settings.sidebar.panel_selected_artwork_mask_posx <- settings.sidebar.panel_selected_artwork_posx;
        settings.sidebar.panel_selected_artwork_mask_posy_offset <- settings.sidebar.panel_selected_artwork_posy_offset;
        settings.sidebar.panel_selected_artwork_mask_dimensions <- scalar2(settings.sidebar.panel_selected_artwork_dimensions.w, settings.sidebar.panel_selected_artwork_dimensions.h);
        settings.sidebar.panel_selected_text_posx <- convert_width(148);
        settings.sidebar.panel_selected_text_dimensions <- scalar2(((settings.sidebar.panel_dimensions.w - settings.sidebar.panel_selected_text_posx) + settings.sidebar.panel_selected_arrow_dimensions.w) - convert_width(30), settings.sidebar.panel_selected_dimensions.h - convert_height(16));
        settings.sidebar.panel_selected_text_posy_offset <- (settings.sidebar.panel_selected_dimensions.h - settings.sidebar.panel_selected_text_dimensions.h) / 2;
        settings.sidebar.panel_selected_text_width_offset <- convert_width(23);
        settings.sidebar.panel_selected_text_font <- "Lato-Black.ttf";
        settings.sidebar.panel_selected_text_align <- Align.Left;
        settings.sidebar.panel_selected_text_word_wrap <- true;
        settings.sidebar.panel_selected_index <- ((settings.sidebar.numpanels + (settings.sidebar.numpanels % 2)) / 2) - 1;

        settings.infopanel.game_info_1 <- get_user_config("game_info_1");
        settings.infopanel.game_info_2 <- get_user_config("game_info_2");

        settings.infopanel.shadow_strength <- get_strength(get_user_config("shadow_strength"));

        settings.infopanel.filter_text_width_offset <- convert_width(50);
        settings.infopanel.filter_text_font <- "Lato-Black.ttf";
        settings.infopanel.filter_text_align <- Align.Right;
        settings.infopanel.filter_text_word_wrap <- true;

        settings.infopanel.game_text_width_offset <- convert_width(50);
        settings.infopanel.game_text_font <- "Lato-Black.ttf";
        settings.infopanel.game_text_align <- Align.Right;
        settings.infopanel.game_text_word_wrap <- true;

//        settings.mainmenu.panels <- [];
//        settings.mainmenu.panels.append(::MainMenuPanel("GAME INFO", "images/menu_icons/icon_info.png", "menu", "gameinfo"));
//        settings.mainmenu.panels.append(::MainMenuPanel("", "", "signal", "add_favourite"));
//        settings.mainmenu.panels.append(::MainMenuPanel("FILTERS", "images/menu_icons/icon_filters.png", "menu", "filters"));
//        settings.mainmenu.panels.append(::MainMenuPanel("SYSTEMS", "images/menu_icons/icon_system.png", "menu", "systems"));
//        settings.mainmenu.panels.append(::MainMenuPanel("SETTINGS", "images/menu_icons/icon_settings.png", "signal", "configure"));
//        settings.mainmenu.panels.append(::MainMenuPanel("EXIT", "images/menu_icons/icon_exit.png", "signal", "exit_no_menu"));

//        settings.mainmenu.fav_icon_add <- "images/menu_icons/icon_fav_add.png";
//        settings.mainmenu.fav_icon_remove <- "images/menu_icons/icon_fav_remove.png";
//        settings.mainmenu.fav_label_add <- "FAV ADD";
//        settings.mainmenu.fav_label_remove <- "FAV REMOVE";

 //       settings.mainmenu.button <- get_user_config("main_menu_button");
 //       settings.mainmenu.remember_pos <- get_user_config("main_menu_remember");
 //       settings.mainmenu.surface_dimensions <- convert_scalar2(scalar2(settings.base_dimensions.w, settings.base_dimensions.h));
 //       settings.mainmenu.surface_pos <- scalar2(0, 0);
 //       settings.mainmenu.menu_surface_dimensions <- convert_scalar2(scalar2(760, 840));
 //       settings.mainmenu.menu_surface_pos <- scalar2((settings.mainmenu.surface_dimensions.w / 2) - (settings.mainmenu.menu_surface_dimensions.w / 2), (settings.mainmenu.surface_dimensions.h / 2) - (settings.mainmenu.menu_surface_dimensions.h / 2));
 //       settings.mainmenu.menu_label_bg_dimensions <- scalar2(settings.mainmenu.menu_surface_dimensions.w, settings.mainmenu.menu_surface_dimensions.h / (settings.mainmenu.panels.len() + 1));
 //       settings.mainmenu.menu_label_icon_image <- "images/menu_icons/icon_main_menu.png";
 //       settings.mainmenu.menu_label_icon_dimensions <- scalar2(settings.mainmenu.menu_label_bg_dimensions.h, settings.mainmenu.menu_label_bg_dimensions.h);
 //       settings.mainmenu.menu_label_icon_pos <- convert_scalar2(scalar2(25, 0));

//        settings.mainmenu.menu_label_text <- "MAIN MENU";
//        settings.mainmenu.menu_label_text_dimensions <- scalar2(settings.mainmenu.menu_surface_dimensions.w - settings.mainmenu.menu_label_icon_dimensions.w, settings.mainmenu.menu_surface_dimensions.h / (settings.mainmenu.panels.len() + 1));
//        settings.mainmenu.menu_label_text_pos <- scalar2(settings.mainmenu.menu_label_icon_dimensions.w, 0);
//        settings.mainmenu.menu_label_text_font <- "Lato-Heavy.ttf";
//        settings.mainmenu.menu_label_text_align <- Align.Left;
//        settings.mainmenu.menu_label_text_charsize <- convert_height(78);


        // settings.overlaymenu.label <- "Options Menu";
        // settings.overlaymenu.options_items <- [];
        // settings.overlaymenu.options_actions <- [];

        // settings.overlaymenu.options_items.append("Toggle favourite");
        // settings.overlaymenu.options_items.append("Filters menu");
        // if (get_user_config("options_history") == "Enabled") settings.overlaymenu.options_items.append("History");
        // if (get_user_config("options_mameinfo") == "Enabled") settings.overlaymenu.options_items.append("MAMEInfo");
        // settings.overlaymenu.options_items.append("Displays menu");
        // settings.overlaymenu.options_items.append("Toggle audio mute");
        // settings.overlaymenu.options_items.append("Enable screensaver");
        // settings.overlaymenu.options_items.append("Configuration");
        // settings.overlaymenu.options_items.append("Exit Attract-Mode");

        // settings.overlaymenu.options_actions.append("add_favourite");
        // settings.overlaymenu.options_actions.append("filters_menu");
        // if (get_user_config("options_history") == "Enabled") settings.overlaymenu.options_actions.append("do_history");
        // if (get_user_config("options_mameinfo") == "Enabled") settings.overlaymenu.options_actions.append("do_mameinfo");
        // settings.overlaymenu.options_actions.append("displays_menu");
        // settings.overlaymenu.options_actions.append("toggle_mute");
        // settings.overlaymenu.options_actions.append("screen_saver");
        // settings.overlaymenu.options_actions.append("configure");
        // settings.overlaymenu.options_actions.append("exit_no_menu");

//        settings.mamedats.history_enabled <- (get_user_config("options_history") == "Enabled") ? true : false;
//        settings.mamedats.mameinfo_enabled <- (get_user_config("options_mameinfo") == "Enabled") ? true : false;
//        settings.mamedats.historydat_path <- get_user_config("historydat_path");
//        settings.mamedats.mameinfodat_path <- get_user_config("mameinfodat_path");
//        settings.mamedats.index_clones <- get_user_config("index_clones");

//        settings.mamedats.surface_dimensions <- convert_scalar2(scalar2(settings.base_dimensions.w, settings.base_dimensions.h));
//        settings.mamedats.surface_pos <- scalar2(0, 0);
//        settings.mamedats.bg_image <- "images/pixel.png";
//        settings.mamedats.bg_dimensions <- scalar2(settings.mamedats.surface_dimensions.w, settings.mamedats.surface_dimensions.h);
//        settings.mamedats.bg_pos <- scalar2(0, 0);
//        settings.mamedats.text_font <- "Lato-Regular.ttf";
//        settings.mamedats.text_dimensions <- scalar2(settings.bg.dimensions.w - (settings.sidebar.panel_selected_arrow_dimensions.w) , settings.bg.dimensions.h);
//        settings.mamedats.text_pos <- scalar2(settings.bg.pos.x + (settings.sidebar.panel_selected_arrow_dimensions.w), settings.bg.pos.y);
//        settings.mamedats.text_charsize <- round(settings.mamedats.text_dimensions.h / settings.mamedats.text_lines);
    }

    function convert_scalar2(value)
    {
        local percentage = vec2(value / settings.base_dimensions);
        return scalar2(percentage * get_layout_dimensions());
    }

    function convert_width(value)
    {
        local percentage = value / settings.base_dimensions.w.tofloat();
        return round(percentage * get_layout_dimensions().w);
    }

    function convert_height(value)
    {
        local percentage = value / settings.base_dimensions.h.tofloat();
        return round(percentage * get_layout_dimensions().h);
    }
}
