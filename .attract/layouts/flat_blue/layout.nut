/*

FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End

graphic design by: www.ClanLogoDesign.com
layout scripting by: Chris Van Graas
shader code by: Timothy Lottes, LUKE NUKEM, krischan, Chris Van Graas

*/

class UserConfig </help="FLAT BLUE - Aspect and rotation aware layout for Attract-Mode Front-End."/>
{
    </label="Layout rotation", help="Set the rotation of the layout to suit your monitor.", options="None, Right, Flip, Left", order=1/>
    layout_rotation = "None";

    </label="Menu artwork", help="Set menu panel artwork type (round icon).", options="Snap, Flyer, Icon", order=2/>
    menu_art_type = "Snap";

    </label="Menu videos", help="Toggle video playback for menu artwork.", options="Enabled, Disabled", order=3/>
    menu_video = "Disabled";

    </label="Wheel logo", help="Toggle display of game wheel logos.", options="Enabled, Disabled", order=4/>
    show_wheel = "Enabled";

    </label="Game info 1", help="Set game information to display in info panel.", options="Year, ROM Name", order=5/>
    game_info_1 = "Year";

    </label="Game info 2", help="Set game information to display in info panel.", options="Manufacturer, Played Count", order=6/>
    game_info_2 = "Played Count";

    </label="Panel shadows", help="Set menu and information panel shadow effect strength.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=7/>
    shadow_strength = "Medium";

    </label="CRT Shader", help="Toggle CRT Shader for snaps. Disabled for resolutions under 1024x768.", options="Enabled, Disabled", order=8/>
    crt_shader = "Disabled";

    </label="Scanline overlay", help="Set scanline overlay effect strength. Only used if CRT Shader is disabled.", options="Strongest, Strong, Medium, Weak, Weakest, Disabled", order=9/>
    scanline_strength = "Weakest";




}

const LAYOUT_NAME = "FLAT BLUE";
const VERSION = 0.99991;
const DEBUG = false;



fe.load_module("pan-and-scan");
// fe.load_module("submenu");
fe.do_nut("scripts/Helperfunctions.nut");
fe.do_nut("scripts/Vectors.nut");
fe.do_nut("scripts/Layoutsettings.nut");
fe.do_nut("scripts/Sidebar.nut");
fe.do_nut("scripts/Mamedats.nut");
fe.do_nut("scripts/Mainmenu.nut");
fe.do_nut("scripts/Background.nut");
fe.do_nut("scripts/Infopanel.nut");
// fe.do_nut("scripts/Overlaymenu.nut");

local layout = LayoutSettings();

local test_resolution = scalar2();

// test_resolution = scalar2(1920,1080);
// test_resolution = scalar2(1366,768);
// test_resolution = scalar2(1360,768);
// test_resolution = scalar2(1024,576);

// test_resolution = scalar2(1920,1200);
// test_resolution = scalar2(1280,768);
// test_resolution = scalar2(800,480);

// test_resolution = scalar2(1600,1280);
// test_resolution = scalar2(1280,1024);

// test_resolution = scalar2(1600,1200);
// test_resolution = scalar2(1024,768);
// test_resolution = scalar2(800,600);
// test_resolution = scalar2(640,480);
// test_resolution = scalar2(320,240);

// layout.set_layout_dimensions(test_resolution);

layout.initialize();

Background(layout.settings);
SideBarMenu(layout.settings);
InfoPanel(layout.settings);
MainMenu(layout.settings);

