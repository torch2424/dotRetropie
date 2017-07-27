/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

OverlayMenu class

    constructor(array, array, string, string)
        Creates a custom overlay menu using Attract-Mode's built in system.
        Must provide the following arguments:
            A string array of menu item labels,
            A string array of actions to perform for each item (currently only accepts signals),
            A string containing the keycode for the button to open the menu,
            A string containing the label for the overlay menu.

*/

class OverlayMenu
{
    items = null;
    actions = null;
    button = null;
    label = null;
    historyviewer = null;
    mameinfoviewer = null;
    settings = null;

    constructor(layout_settings)
    {
        settings = layout_settings.overlaymenu;

        items = settings.options_items;
        actions = settings.options_actions;
        button = settings.button;
        label = settings.label;

        historyviewer = HistoryViewer(layout_settings);
        mameinfoviewer = MAMEInfoViewer(layout_settings);

        fe.add_ticks_callback(this, "OnTick");
    }

    function OnTick( ttime )
    {
        if (fe.get_input_state(button))
        {
            local selected = fe.overlay.list_dialog(items, label);
            if ((selected < 0) || (selected >= actions.len()) || (actions[selected].len() < 1))
                return;

            if (actions[selected] == "do_history")
            {
                historyviewer.show(false);
                mameinfoviewer.show(false);

                historyviewer.show(true);
                return;
            }
            else if (actions[selected] == "do_mameinfo")
            {
                historyviewer.show(false);
                mameinfoviewer.show(false);

                mameinfoviewer.show(true);
                return;
            }
            fe.signal(actions[selected]);
        }
    }
}