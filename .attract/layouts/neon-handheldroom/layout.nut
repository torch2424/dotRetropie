////////////////////////////////////////////////////////////////////////////////////////////////////////
// Updated 4/26/2016 by omegaman                                                                      
// Attract-Mode "Robospin" layout. Thanks to verion for cleaning cab skins and to malfacine's for glogos code                            
// Notes: Implemented crhisv's pan-and-scan module. Added, game and gategory logos, cometic changes.  
// When game marquee is turned off, console marquees will be turned on.     
////////////////////////////////////////////////////////////////////////////////////////////////////////   

class UserConfig {
   </ label="Select bg image or panscan", help="Select bg image or panscan art(flyer)", options="bkg_handheld", order=1 /> enable_image="bkg_handheld";   
   </ label="Select cab skin", help="Select a cab skin image", options="cab_handheld", order=2 /> enable_cab="cab_handheld";
   </ label="Select spinwheel art", help="The artwork to spin", options="marquee, wheel", order=3 /> orbit_art="wheel";
   </ label="Select listbox, wheel, vert_wheel", help="Select wheel art type", options="listbox, wheel, vert_wheel", order=4 /> enable_list_type="wheel";
   </ label="Enable snap static effect", help="Show static effect when snap is null", options="yes,no", order=5 /> enable_static="yes"; 
   </ label="Enable snap bloom shader effect", help="Bloom effect uses shader", options="Yes,No", order=6 /> enable_bloom="No";
   </ label="Enable crt shader effect", help="CRT effect uses shader)", options="Yes,No", order=7 /> enable_crt="No";
   </ label="Enable random Text Colors", help=" Select random text colors.", options="yes,no", order=9 /> enable_colors="yes";
   </ label="Transition Time", help="Time in milliseconds for wheel spin.", order=10 /> transition_ms="50";
   </ label="Enable system logos", help="Select system logos", options="Yes,No", order=11 /> enable_slogos="Yes"; 
   </ label="Enable game marquees", help="Show game marquees", options="Yes,No", order=12 /> enable_marquee="No";
   </ label="Enable lighted marquee effect", help="show lighted Marquee", options="Yes,No", order=13 /> enable_Lmarquee="No";
   </ label="Select pointer", help="Select animated pointer", options="rocket,hand,emulator,none", order=14 /> enable_pointer="emulator"; 
   </ label="Enable text frame", help="Show text frame", options="yes,no", order=15 /> enable_frame="yes"; 
   </ label="Enble background Scanline", help="Show scanline effect", options="none,light,medium,dark", order=17 /> enable_scanline="none";
   </ label="Enable MFR game logos", help="Select game logos", options="Yes,No", order=18 /> enable_mlogos="Yes";
}  

local my_config = fe.get_config();
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
fe.layout.font="Roboto";
const SNAPBG_ALPHA = 200;

// modules
fe.load_module( "animate" );
fe.load_module( "pan-and-scan" );

// Select background or pan-and-scan 
if ( my_config["enable_image"] == "bkg_handheld") 
{
local bg = fe.add_image( "bkg_handheldroom.png", 0, 0, flw, flh );
bg.alpha=255;
}

if ( my_config["enable_image"] == "panscan") 
{
local bgart = PanAndScanArt( "flyer", 0, 0, flw, flh);
bgart.trigger = Transition.EndNavigation;
bgart.preserve_aspect_ratio = false;
bgart.set_fit_or_fill("fill");
bgart.set_anchor(::Anchor.Center);
bgart.set_zoom(4.5, 0.00008);
bgart.set_animate(::AnimateType.Bounce, 0.50, 0.50)
bgart.set_randomize_on_transition(true);
bgart.set_start_scale(1.1);
 local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 0,
    end = 200,
    time = 3000
}
animation.add( PropertyAnimation( bgart, alpha_cfg ) );
}

//scanline effect overlay for bg art
if ( my_config["enable_scanline"] == "none" )
{
local scanline = fe.add_image( "", 0, 0, flw, flh );
}

if ( my_config["enable_scanline"] == "light" )
{
local scanline = fe.add_image( "scan.png", 0, 0, flw, flh );
scanline.preserve_aspect_ratio = false;
scanline.alpha = 100;
}

if ( my_config["enable_scanline"] == "medium" )
{
local scanline = fe.add_image( "scan.png", 0, 0, flw, flh );
scanline.preserve_aspect_ratio = false;
scanline.alpha = 200;
}

if ( my_config["enable_scanline"] == "dark" )
{
local scanline = fe.add_image( "scan.png", 0, 0, flw, flh );
scanline.preserve_aspect_ratio = false;
scanline.alpha = 255;
}

//static effect for cab monitor when no snap is found
local snapbg=null;
if ( my_config["enable_static"] == "yes" )
{
    snapbg = fe.add_image("static.mp4", flx*0.593, fly*0.31, flw*0.161, flh*0.165 );
    snapbg.trigger = Transition.EndNavigation;
    snapbg.skew_y = -fly*0.001
    snapbg.skew_x = -flx*0.015;
    snapbg.pinch_y = -28;
    snapbg.pinch_x = 0;
    snapbg.rotation = -9;
	snapbg.set_rgb( 155, 155, 155 );
	snapbg.alpha = SNAPBG_ALPHA;
}
else 
{
	local temp = fe.add_text("", 224, 59, 352, 264 );
	temp.bg_alpha = SNAPBG_ALPHA;
}

//create surface for snap
local surface = fe.add_surface( 640, 480 );
local snap = surface.add_artwork("snap", 0, 0, 640, 480);
snap.trigger = Transition.EndNavigation;
snap.preserve_aspect_ratio = false;

//now position and pinch the surface
surface.set_pos(flx*0.593, fly*0.31, flw*0.161, flh*0.165);
surface.skew_y = -fly*0.001;
surface.skew_x = -flx*0.015;
surface.pinch_y = -28;
surface.pinch_x = 0;
surface.rotation = -9;

// add shader support because I can
if ( my_config["enable_bloom"] == "Yes" )
{
    local sh = fe.add_shader( Shader.Fragment, "bloom_shader.frag" );
	sh.set_texture_param("bgl_RenderedTexture"); 
	surface.shader = sh;
}

if ( my_config["enable_crt"] == "Yes" )
{
    local sh = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
	sh.set_param( "rubyInputSize", 640, 480 );
    sh.set_param( "rubyOutputSize", ScreenWidth, ScreenHeight );
    sh.set_param( "rubyTextureSize", 640, 480 );
	sh.set_texture_param("rubyTexture"); 
	surface.shader = sh;
}

if ( my_config["enable_marquee"] == "Yes" )
{
local marquee = fe.add_artwork("marquee", flx*0.117, fly*0.086, flw*0.35, flh*0.14 );
 marquee.trigger = Transition.EndNavigation;
 marquee.skew_x = 11;
 marquee.pinch_x = -2;
 marquee.pinch_y = 3;
 marquee.rotation = -1.5;
   if ( my_config["enable_Lmarquee"] == "Yes" )
{
    local shader = fe.add_shader( Shader.Fragment "bloom_shader.frag" );
	shader.set_texture_param("bgl_RenderedTexture"); 
	marquee.shader = shader;
}

}
 else 
 {
 local clogos = fe.add_image("clogos/[Emulator]", flx*0.048, fly*0.045, flw*0.143, flh*0.088 );
 clogos.trigger = Transition.EndNavigation;
 clogos.skew_y = 0;
 clogos.skew_x = flx*0.013;
 clogos.pinch_x = 0;
 clogos.pinch_y = 6;
 clogos.rotation = 16;
 }

//cabinet image
if ( my_config["enable_cab"] == "cab_handheld" )
{
  local cab = fe.add_image( "cab_handheld.png", 0, 0, flw, flh );
} 

//add frame to make text standout 
if ( my_config["enable_frame"] == "yes" )
{
local frame = fe.add_image( "frame.png", 0, fly*0.94, flw, flh*0.05 );
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

//listbox
if ( my_config["enable_list_type"] == "listbox" )
{
local sort_listbox = fe.add_listbox( 176, 96, 45, 202 );
sort_listbox.rows = 13;
sort_listbox.charsize = 10;
sort_listbox.set_rgb( 0, 0, 0 );
sort_listbox.format_string = "[SortValue]";
sort_listbox.bg_alpha=255;
sort_listbox.visible = false;

local listbox = fe.add_listbox(flx*0.56, fly*0.12, flw*0.41, flh*0.8 );
listbox.rows = 13;
listbox.charsize = 18;
listbox.set_rgb( 255, 255, 255 );
listbox.bg_alpha = 90;
listbox.align = Align.Left;
listbox.selbg_alpha = 90;
listbox.sel_red = 255;
listbox.sel_green = 255;
listbox.sel_blue = 0;
}

//This enables vertical art instead of default wheel
if ( my_config["enable_list_type"] == "vert_wheel" )
{
fe.load_module( "conveyor" );
local wheel_x = [ flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.66, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.28, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.168,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
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
 
if ( my_config["enable_list_type"] == "wheel" )
{
fe.load_module( "conveyor" );
local wheel_x = [ flx*0.80, flx*0.795, flx*0.756, flx*0.725, flx*0.70, flx*0.68, flx*0.63, flx*0.68, flx*0.70, flx*0.725, flx*0.756, flx*0.76, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.28, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.168,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
local wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
local num_arts = 10;

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

//property animation - wheel pointers
if ( my_config["enable_pointer"] == "emulator") 
{
local point = fe.add_image("pointers/[Emulator]", flx*0.88, fly*0.34, flw*0.2, flh*0.35);

local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 110,
    end = 255,
    time = 300
}
animation.add( PropertyAnimation( point, alpha_cfg ) );

local movey_cfg = {
    when = Transition.ToNewSelection,
    property = "y",
    start = point.y,
    end = point.y,
    time = 200
}
animation.add( PropertyAnimation( point, movey_cfg ) );

local movex_cfg = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*0.83,
    end = point.x,
    time = 200	
}	
animation.add( PropertyAnimation( point, movex_cfg ) );
}

if ( my_config["enable_pointer"] == "rocket") 
{
local point = fe.add_image("pointers/pointer.png", flx*0.88, fly*0.34, flw*0.2, flh*0.35);

local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 110,
    end = 255,
    time = 300
}
animation.add( PropertyAnimation( point, alpha_cfg ) );

local movey_cfg = {
    when = Transition.ToNewSelection,
    property = "y",
    start = point.y,
    end = point.y,
    time = 200
}
animation.add( PropertyAnimation( point, movey_cfg ) );

local movex_cfg = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*0.83,
    end = point.x,
    time = 200	
}	
animation.add( PropertyAnimation( point, movex_cfg ) );
}

if ( my_config["enable_pointer"] == "hand") 

 {
 local point = fe.add_image("pointers/pointer2.png", flx*0.88, fly*0.34, flw*0.2, flh*0.35);
 local alpha_cfg = {
    when = Transition.ToNewSelection,
    property = "alpha",
    start = 110,
    end = 255,
    time = 300
}
animation.add( PropertyAnimation( point, alpha_cfg ) );

local movey_cfg = {
    when = Transition.ToNewSelection,
    property = "y",
    start = point.y,
    end = point.y,
    time = 200
}
animation.add( PropertyAnimation( point, movey_cfg ) );

local movex_cfg = {
    when = Transition.ToNewSelection,
    property = "x",
    start = flx*0.83,
    end = point.x,
    time = 200	
}	
animation.add( PropertyAnimation( point, movex_cfg ) );
}

if ( my_config["enable_pointer"] == "none") 
{
 local point = fe.add_image( "", 0, 0, 0, 0 );
}

//category icons 

local glogo1 = fe.add_image("glogos/unknown1.png", flx*0.12, fly*0.943, flw*0.045, flh*0.045);
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


//System Logos
if ( my_config["enable_slogos"] == "Yes")  
{
local slogos = fe.add_image("slogos/[Emulator]", flx*0.001, fly*0.18, flw*0.11, flh*0.05 );
slogos.trigger = Transition.EndNavigation;
slogos.rotation = -15; 
}		


//Game MFR Logos
if ( my_config["enable_mlogos"] == "Yes")  
{
local mlogos = fe.add_image("mlogos/[Manufacturer]", flx*0.01, fly*0.942, flw*0.06, flh*0.045 );
mlogos.trigger = Transition.EndNavigation;
}		

// random number for the RGB levels
if ( my_config["enable_colors"] == "yes" )
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
  filter.set_rgb(red,green,blue);
  texty.set_rgb (red,green,blue);
  textt.set_rgb (red,green,blue);
  break;
 }
 return false;
 }
}

//Are we done yet?
