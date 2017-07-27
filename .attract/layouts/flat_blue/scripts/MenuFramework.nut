/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

MenuFramework class

*/

class MenuFrameworkPanel
{
    
    function draw_unselected()
    {
    }

    function draw_selected()
    {
    }
}

class MenuFramework
{
    _panels = null;
    _base_surface = null;
    _menu_surface = null;
    _selected_index = null;
    _label = null;

    constructor()
    {
        _panels = [];
        _base_surface = ::fe.add_surface(1, 1);
        _base_surface.visible = false;
        _selected_index = 0;
        _label = "";
    }

    //
    // Properties
    //
    function _get(key)
    {
        switch (key)
        {
            case "visible":
            case "width":
            case "height":
            case "x":
            case "y":
                return _surface[key];
                break;
            case "label":
                return _label;
            default:
                throw null;
                break;
        }
    }
    function _set(key, value)
    {
        switch (key)
        {
            case "visible":
                _surface[key] = value;
                break;
            case "width":
                _set_width(value);
                break;
            case "height":
                _set_height(value);
                break;
            case "x":
                _set_pos_x(value);
                break;
            case "y":
                _set_pos_y(value);
                break;
            case "label":
                _label = value;
                break;
            default:
                throw null;
                break;
        }
    }
    function _typeof() { return "menuframework"; }

    //
    // Private Methods
    //
    function _set_width(value)
    {
        _surface.width = value;
    }

    function _set_height(value)
    {
        _surface.height = value;
    }

    function _set_pos_x(value)
    {
        _surface.x = value;
    }

    function _set_pos_y(value)
    {
        _surface.y = value;
    }

    //
    // Public Methods
    //
    function set_pos(x_value, y_value)
    {
        _set_pos_x(x_value);
        _set_pos_y(y_value);
    }

    function set_size(w_value, h_value)
    {
        _set_width(w_value);
        _set_height(h_value);
    }

    function add_panel()
    {

    }

    function draw()
    {

    }
}