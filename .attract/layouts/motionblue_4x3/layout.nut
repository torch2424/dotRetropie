////////////////////////////////////////////////////////////////////////////////////////////////////////
//
// 10/11/2016 updated by DGM for the RetroPie Facebook group 
// Updated and enhanced to now include many new features and options
//
// Updated 9/08/2016 by omegaman                                                                      
// Attract-Mode "Robospin" layout. Thanks to verion for cleaning cab skins and to malfacine's for glogos                             
// Notes: Lots of changes...  
////////////////////////////////////////////////////////////////////////////////////////////////////////   

class UserConfig {
</ label="--------  Main theme layout  --------", help="Show or hide additional images", order=1 /> uct1="select below";
   </ label="Select background color", help="Select background color", options="blue,gray,green,orange,red", order=2 /> enable_background="blue";
   </ label="Select cabinet  color", help="Select cabinet color", options="blue,gray,green,orange,red", order=3 /> enable_cab="blue";
   </ label="Select listbox, wheel, vert_wheel", help="Select wheel type or listbox", options="vert_wheel", order=4 /> enable_list_type="vert_wheel";
   </ label="Select spinwheel art", help="The artwork to spin", options="marquee,wheel", order=5 /> orbit_art="wheel";
   </ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=6 /> transition_ms="35";  
</ label=" ", help=" ", options=" ", order=7 /> divider1="";
</ label="--------    Game info box    --------", help="Show or hide game info box", order=8 /> uct5="select below";
   </ label="Enable game information", help="Show game information", options="Yes,No", order=9 /> enable_ginfo="Yes";
   </ label="Enable text frame", help="Show text frame", options="Yes,No", order=10 /> enable_frame="Yes"; 
   </ label="Enable system logo", help="Show system logo", options="Yes,No", order=11 /> enable_logo="Yes";
</ label=" ", help=" ", options=" ", order=12 /> divider5="";
</ label="--------    Miscellaneous    --------", help="Miscellaneous options", order=13 /> uct6="select below";
   </ label="Enable random text colors", help=" Select random text colors.", options="Yes,No", order=14 /> enable_colors="Yes";
   </ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=15 /> enable_static="Yes"; 
}  

local my_config = fe.get_config();
local flx = fe.layout.width=640;
local fly = fe.layout.height=480;
local flw = fe.layout.width;
local flh = fe.layout.height;
//fe.layout.font="Roboto";

// modules
fe.load_module("fade");
fe.load_module( "animate" );



// Load background image
if ( my_config["enable_background"] == "blue" )
{
local bgsolid = fe.add_image( "backgrounds/motion_blue.mp4", 0, 0, flw, flh );
bgsolid.alpha=255;
}

if ( my_config["enable_background"] == "gray" )
{
local bgsolid = fe.add_image( "backgrounds/motion_gray.mp4", 0, 0, flw, flh );
bgsolid.alpha=255;
}

if ( my_config["enable_background"] == "green" )
{
local bgsolid = fe.add_image( "backgrounds/motion_green.mp4", 0, 0, flw, flh );
bgsolid.alpha=255;
}

if ( my_config["enable_background"] == "orange" )
{
local bgsolid = fe.add_image( "backgrounds/motion_orange.mp4", 0, 0, flw, flh );
bgsolid.alpha=255;
}

if ( my_config["enable_background"] == "red" )
{
local bgsolid = fe.add_image( "backgrounds/motion_red.mp4", 0, 0, flw, flh );
bgsolid.alpha=255;
}

// Video Preview or static video if none available
// remember to make both sections the same dimensions and size
if ( my_config["enable_static"] == "Yes" )
{
//adjust the values below for the static preview video snap
   const SNAPBG_ALPHA = 200;
   local snapbg=null;
   snapbg = fe.add_image( "static.mp4", flx*0.265, fly*0.085, flw*0.46, flh*0.56 );
   snapbg.trigger = Transition.EndNavigation;
   snapbg.skew_y = 0;
   snapbg.skew_x = 0;
   snapbg.pinch_y = 0;
   snapbg.pinch_x = 0;
   snapbg.rotation = 0;
   snapbg.set_rgb( 155, 155, 155 );
   snapbg.alpha = SNAPBG_ALPHA;
}
 else
 {
 local temp = fe.add_text("", flx*0.092, fly*0.38, flw*0.226, flh*0.267 );
 temp.bg_alpha = SNAPBG_ALPHA;
 }

//create surface for snap
local surface_snap = fe.add_surface( 640, 480 );
local snap = FadeArt("snap", 0, 0, 640, 480, surface_snap);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = false;

//now position and pinch surface of snap
//adjust the below values for the game video preview snap
surface_snap.set_pos(flx*0.265, fly*0.09, flw*0.46, flh*0.555);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = 0;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;



// Load cabinet image
if ( my_config["enable_cab"] == "blue" )
{
local cabsolid = fe.add_image( "backgrounds/bkg_blue.png", 0, 0, flw, flh );
cabsolid.alpha=255;
}

if ( my_config["enable_cab"] == "gray" )
{
local cabsolid = fe.add_image( "backgrounds/bkg_gray.png", 0, 0, flw, flh );
cabsolid.alpha=255;
}

if ( my_config["enable_cab"] == "green" )
{
local cabsolid = fe.add_image( "backgrounds/bkg_green.png", 0, 0, flw, flh );
cabsolid.alpha=255;
}

if ( my_config["enable_cab"] == "orange" )
{
local cabsolid = fe.add_image( "backgrounds/bkg_orange.png", 0, 0, flw, flh );
cabsolid.alpha=255;
}

if ( my_config["enable_cab"] == "red" )
{
local cabsolid = fe.add_image( "backgrounds/bkg_red.png", 0, 0, flw, flh );
cabsolid.alpha=255;
}

// Show the system logo wheel at the top of the screen
if ( my_config["enable_logo"] == "Yes" )
{
local logo = fe.add_image("systemlogo/[DisplayName]", flx*0.43, fly*0.001 flw*0.15, flh*0.1 );
}

// The following section sets up what type and wheel and displays the users choice

//vertical wheel with three wheels shown horizontal
if ( my_config["enable_list_type"] == "vert_wheel" )
{
fe.load_module( "conveyor" );
local wheel_x = [ -flx*0.45, -flx*0.3, -flx*0.2, -flx*0.04, flx*0.12 flx*0.28, flx*0.44, flx*0.6, flx*0.76 flx*0.92, flx*1.08, flx*1.24 ];
local wheel_y = [ fly*0.78, fly*0.78, fly*0.78, fly*0.78, fly*0.78, fly*0.78, fly*0.76, fly*0.78, fly*0.78, fly*0.78, fly*0.78, fly*0.78, ]; 
local wheel_w = [ flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, flw*0.13, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122, flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122,  flh*0.122, ];
local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 12;

class WheelEntry extends ConveyorSlot
{
	constructor()
	{
		base.constructor( ::fe.add_artwork( my_config["orbit_art"] ) );
	}

	function on_progress( progress, var )
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;
		
		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = wheel_x[slot] + p * ( wheel_x[slot+1] - wheel_x[slot] );
		m_obj.y = wheel_y[slot] + p * ( wheel_y[slot+1] - wheel_y[slot] );
		m_obj.width = wheel_w[slot] + p * ( wheel_w[slot+1] - wheel_w[slot] );
		m_obj.height = wheel_h[slot] + p * ( wheel_h[slot+1] - wheel_h[slot] );
		m_obj.rotation = wheel_r[slot] + p * ( wheel_r[slot+1] - wheel_r[slot] );
		m_obj.alpha = wheel_a[slot] + p * ( wheel_a[slot+1] - wheel_a[slot] );
	}
};

local wheel_entries = [];
for ( local i=0; i<num_arts/2; i++ )
	wheel_entries.push( WheelEntry() );

local remaining = num_arts - wheel_entries.len();

// we do it this way so that the last wheelentry created is the middle one showing the current
// selection (putting it at the top of the draw order)
for ( local i=0; i<remaining; i++ )
	wheel_entries.insert( num_arts/2, WheelEntry() );

local conveyor = Conveyor();
conveyor.set_slots( wheel_entries );
conveyor.transition_ms = 50;
try { conveyor.transition_ms = my_config["transition_ms"].tointeger(); } catch ( e ) { }
}


// Game information to show inside text box frame
if ( my_config["enable_ginfo"] == "Yes" )
{

//add frame to make text standout 
if ( my_config["enable_frame"] == "Yes" )
{
local frame = fe.add_image( "frame.png", 0, fly*0.94, flw, flh*0.06 );
frame.alpha = 255;
}

//Year text info
local texty = fe.add_text("[Year]", flx*0.18, fly*0.937, flw*0.13, flh*0.055 );
texty.set_rgb( 255, 255, 255 );
//texty.style = Style.Bold;
//texty.align = Align.Left;

//Title text info
local textt = fe.add_text( "[Title]", flx*0.315, fly*0.955, flw*0.6, flh*0.025  );
textt.set_rgb( 225, 255, 255 );
//textt.style = Style.Bold;
textt.align = Align.Left;
textt.rotation = 0;
textt.word_wrap = true;

//display filter info
local filter = fe.add_text( "[ListFilterName]: [ListEntry]-[ListSize]  [PlayedCount]", flx*0.7, fly*0.962, flw*0.3, flh*0.02 );
filter.set_rgb( 255, 255, 255 );
//filter.style = Style.Italic;
filter.align = Align.Right;
filter.rotation = 0;

//category icons 

local glogo1 = fe.add_image("glogos/unknown1.png", flx*0.12, fly*0.945, flw*0.045, flh*0.05);
glogo1.trigger = Transition.EndNavigation;

class GenreImage1
{
    mode = 1;       //0 = first match, 1 = last match, 2 = random
    supported = {
        //filename : [ match1, match2 ]
        "action": [ "action" ],
        "adventure": [ "adventure" ],
        "fighting": [ "fighting", "fighter", "beat'em up" ],
        "platformer": [ "platformer", "platform" ],
        "puzzle": [ "puzzle" ],
        "maze": [ "maze" ],
		"paddle": [ "paddle" ],
		"rhythm": [ "rhythm" ],
		"pinball": [ "pinball" ],
		"racing": [ "racing", "driving" ],
        "rpg": [ "rpg", "role playing", "role-playing" ],
        "shooter": [ "shooter", "shmup" ],
        "sports": [ "sports", "boxing", "golf", "baseball", "football", "soccer" ],
        "strategy": [ "strategy"]
    }

    ref = null;
    constructor( image )
    {
        ref = image;
        fe.add_transition_callback( this, "transition" );
    }
    
    function transition( ttype, var, ttime )
    {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.ToNewList )
        {
            local cat = " " + fe.game_info(Info.Category, var).tolower();
            local matches = [];
            foreach( key, val in supported )
            {
                foreach( nickname in val )
                {
                    if ( cat.find(nickname, 0) ) matches.push(key);
                }
            }
            if ( matches.len() > 0 )
            {
                switch( mode )
                {
                    case 0:
                        ref.file_name = "glogos/" + matches[0] + "1.png";
                        break;
                    case 1:
                        ref.file_name = "glogos/" + matches[matches.len() - 1] + "1.png";
                        break;
                    case 2:
                        local random_num = floor(((rand() % 1000 ) / 1000.0) * ((matches.len() - 1) - (0 - 1)) + 0);
                        ref.file_name = "glogos/" + matches[random_num] + "1.png";
                        break;
                }
            } else
            {
                ref.file_name = "glogos/unknown1.png";
            }
        }
    }
}
GenreImage1(glogo1);


// random number for the RGB levels
if ( my_config["enable_colors"] == "Yes" )
{
function brightrand() {
 return 255-(rand()/255);
}

local red = brightrand();
local green = brightrand();
local blue = brightrand();

// Color Transitions
fe.add_transition_callback( "color_transitions" );
function color_transitions( ttype, var, ttime ) {
 switch ( ttype )
 {
  case Transition.StartLayout:
  case Transition.ToNewSelection:
  red = brightrand();
  green = brightrand();
  blue = brightrand();
  //listbox.set_rgb(red,green,blue);
  texty.set_rgb (red,green,blue);
  textt.set_rgb (red,green,blue);
  break;
 }
 return false;
 }
}}


///////////////////////////////////////

// Themed Overlay Display Menu
// Add this block of code to the very end of any layout.nut file to have 
// a centered theme-able menu

const OVERLAY_ALPHA =190;

	// Overall Surface
	local overlaySurface = fe.add_surface(flw,flh);
	overlaySurface.visible = false;
	
	// translucent background
	local overlayBackground = overlaySurface.add_image("menuart/black.png",0,0,flw,flh);
	overlayBackground.alpha = 225;
	
	// create extra surface for the menu
	local overlayMenuSur = overlaySurface.add_surface(322,328);
	overlayMenuSur.set_pos(flx*0.25,fly*0.2);
	overlayMenuSur.add_image("menuart/menuframe1.png",0,40,321,256); // Add the menu frame
	local overlay_lb = overlayMenuSur.add_listbox(1,40,320,256); //Add the listbox
	overlay_lb.rows = 10; // the listbox will have 6 slots
	overlay_lb.charsize  = 20;
	overlay_lb.set_rgb( 128, 128, 128 );
	overlay_lb.sel_style = Style.Bold;
	overlay_lb.set_sel_rgb( 255, 255, 255 );
	overlay_lb.set_selbg_rgb( 255, 165, 0 );

	local overlayMenuTitle = overlayMenuSur.add_text("[DisplayName]",0,0,322,35); //Add the menu title
	overlayMenuTitle.charsize=20;
	overlayMenuTitle.style = Style.Bold;
	overlayMenuTitle.set_rgb(55,165,0);


// I added the following lines to add in a couple of swf files
// Theoretically, you could add as many additional images you wanted all over the screen

	local overlayimage1 = overlaySurface.add_image("menuart/sonic3.swf"); //add a test swf image
	overlayimage1.set_pos(flx*0.2,fly*0.2,flw*0.1,fly*0.2);

	local overlayimage2 = overlaySurface.add_image("menuart/turtle1.swf"); //add a test swf image
	overlayimage2.set_pos(flx*0.7,fly*0.2,flw*0.1,fly*0.2);

        // image overlay to cover up the word Displays with Select System
//	local overlayimage4 = overlaySurface.add_image("selectsystem.png"); //add a test swf image
//	overlayimage4.set_pos(flx*0.37,fly*0.08,flw*0.3,fly*0.2);

// tell Attractmode we are using a custom overlay menu
        fe.overlay.set_custom_controls( overlayMenuTitle, overlay_lb );


//  The following function shows or hides the display menu properly

fe.add_transition_callback( "orbit_transition" );
function orbit_transition( ttype, var, ttime )
{
	switch ( ttype )
	{
 	case Transition.ShowOverlay:
		overlaySurface.visible = true;
		if ( ttime < 255 )
		{
			overlaySurface.alpha = ttime;
			return true;
		}
		else
		{
				overlaySurface.alpha = 255;
		}
		break;
	case Transition.HideOverlay:
		if ( ttime < 255 )
		{
			overlaySurface.alpha = 255 - ttime;
			return true;
		}
		else
		{
			local old_alpha;
				old_alpha = overlaySurface.alpha;
				overlaySurface.alpha = 0;

			if ( old_alpha != 0 )
				return true;
		}
		overlaySurface.visible = false;
		break;
	}
	return false;
}


