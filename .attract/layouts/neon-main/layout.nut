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
   </ label="Select background image", help="Select theme background or flyer", options="static,moving,flyer", order=2 /> enable_bg="moving";   
   </ label="Select cabinet image", help="Select a cab skin image", options="default,MK,MVC,pacman,retropie,tmnt,SNK,Capcom,Data East,advMAME,hacks,MAME4ALL,nintendo classics,sega classics,taito,top 100,williams,atari classics", order=3 /> enable_cab="default";
   </ label="Select listbox, wheel, vert_wheel", help="Select wheel type or listbox", options="listbox, wheel, vert_wheel", order=4 /> enable_list_type="wheel";
   </ label="Select spinwheel art", help="The artwork to spin", options="marquee, wheel", order=5 /> orbit_art="wheel";
   </ label="Wheel transition time", help="Time in milliseconds for wheel spin.", order=6 /> transition_ms="35";  
</ label="--------    Extra images     --------", help="Show or hide additional images", order=7 /> uct2="select below";
   </ label="Enable box art", help="Select box art", options="Yes,No", order=8 /> enable_gboxart="No"; 
   </ label="Enable cartridge art", help="Select cartridge art", options="Yes,No", order=9 /> enable_gcartart="No"; 
   </ label="Enable MFR game logos", help="Select game logos", options="Yes,No", order=10 /> enable_mlogos="No"; 
   </ label="Enable system logos", help="Select system logos", options="Yes,No", order=11 /> enable_slogos="No"; 
</ label="-------- Logo/Marquee images --------", help="Show or hide logo/marquee images", order=12 /> uct3="select below";
   </ label="Enable logos/marquees", help="Show logo or marquees", options="Yes,No", order=13 /> enable_logomarquee="Yes";
   </ label="Select logo or marquee", help="Select logo or marquees", options="logo, emulator, marquee", order=14 /> enable_marquee="logo";
   </ label="Enable lighted marquee effect", help="show lighted Marquee", options="Yes,No", order=15 /> enable_Lmarquee="No";
</ label="--------   Pointer images    --------", help="Change pointer image", order=16 /> uct4="select below";
   </ label="Select pointer", help="Select animated pointer", options="default,emulator,rocket,hand,none", order=17 /> enable_pointer="default"; 
</ label="--------    Game info box    --------", help="Show or hide game info box", order=18 /> uct5="select below";
   </ label="Enable game information", help="Show game information", options="Yes,No", order=19 /> enable_ginfo="No";
   </ label="Enable text frame", help="Show text frame", options="Yes,No", order=20 /> enable_frame="No"; 
</ label="--------    Miscellaneous    --------", help="Miscellaneous options", order=21 /> uct6="select below";
   </ label="Enable random text colors", help=" Select random text colors.", options="Yes,No", order=22 /> enable_colors="Yes";
   </ label="Enble background overlay", help="Select overlay effect; options are masking, scanlines, aperture", options="mask,scanlines,aperture,none", order=23 /> enable_overlay="mask";
   </ label="Enable snap bloom shader effect", help="Bloom effect uses shader", options="Yes,No", order=24 /> enable_bloom="No";
   </ label="Enable crt shader effect", help="CRT effect uses shader", options="Yes,No", order=25 /> enable_crt="No";
   </ label="Enable monitor static effect", help="Show static effect when snap is null", options="Yes,No", order=26 /> enable_static="Yes"; 
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

// Background Art 
// This section will display the two different background art 
// based up on the layout option choice
if ( my_config["enable_bg"] == "moving") 
{
local b_art = fe.add_image("backgrounds/default.swf", 0, 0, flw, flh );
b_art.alpha=255;
}

if ( my_config["enable_bg"] == "static") 
{
local b_art = fe.add_image("backgrounds/default.png", 0, 0, flw, flh );
b_art.alpha=255;
}

if ( my_config["enable_bg"] == "default1") 
{
local b_art = fe.add_image("backgrounds/default1.png", 0, 0, flw, flh );
b_art.alpha=255;
}

if ( my_config["enable_bg"] == "flyer") 
{
local surface_flyer = fe.add_surface( 640, 480 );
local b_art = FadeArt( "flyer", 0, 0, 640, 480, surface_flyer );
b_art.trigger = Transition.EndNavigation;
b_art.preserve_aspect_ratio = false;
b_art.alpha=127;

//now position and rotate surface for flyer
surface_flyer.set_pos(flx*0.4, 0, flw*0.6, flh);
surface_flyer.rotation = 0;
}

//masking effect overlay for bg art

if ( my_config["enable_overlay"] == "mask" )
{
local overlay = fe.add_image( "mask.png", 0, 0, flw, flh );
overlay.preserve_aspect_ratio = false;
overlay.alpha = 200;
}

if ( my_config["enable_overlay"] == "scanlines" )
{
local overlay = fe.add_image( "scanlines.png", 0, 0, flw, flh );
overlay.preserve_aspect_ratio = false;
overlay.alpha = 200;
}

if ( my_config["enable_overlay"] == "aperture" )
{
local overlay = fe.add_image( "aperture.png", 0, 0, flw, flh );
overlay.preserve_aspect_ratio = false;
overlay.alpha = 200;
}

if ( my_config["enable_overlay"] == "none" )
{
local overlay = fe.add_image( "none.png", 0, 0, 0, 0 );
overlay.preserve_aspect_ratio = false;
overlay.alpha = 0;
}

// Video Preview or static video if none available
// remember to make both sections the same dimensions and size
if ( my_config["enable_static"] == "Yes" )
{
//adjust the values below for the static preview video snap
   const SNAPBG_ALPHA = 200;
   local snapbg=null;
   snapbg = fe.add_image( "static.mp4", flx*0.31, fly*0.3, flw*0.24, flh*0.25 );
   snapbg.trigger = Transition.EndNavigation;
   snapbg.skew_y = 0;
   snapbg.skew_x = 0;
   snapbg.pinch_y = -25;
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
surface_snap.set_pos(flx*0.31, fly*0.3, flw*0.24, flh*0.25);
surface_snap.skew_y = 0;
surface_snap.skew_x = 0;
surface_snap.pinch_y = -25;
surface_snap.pinch_x = 0;
surface_snap.rotation = 0;

// add shader support because I can
if ( my_config["enable_bloom"] == "Yes" )
{
    local sh = fe.add_shader( Shader.Fragment, "bloom_shader.frag" );
	sh.set_texture_param("bgl_RenderedTexture"); 
	surface_snap.shader = sh;
}

if ( my_config["enable_crt"] == "Yes" )
{
    local sh = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
	sh.set_param( "rubyInputSize", 640, 480 );
    sh.set_param( "rubyOutputSize", ScreenWidth, ScreenHeight );
    sh.set_param( "rubyTextureSize", 640, 480 );
	sh.set_texture_param("rubyTexture"); 
	surface_snap.shader = sh;
}

// Cabinet image used for displaying the conosle and controller image
if ( my_config["enable_cab"] == "default" )
{
 local cab = fe.add_image( "cabinets/default.png", 0, 0, flw, flh );
}

local girl = fe.add_image("backgrounds/girl.png", 0, 0, flw, flh );

if ( my_config["enable_cab"] == "MK" )
{
 local cab = fe.add_image( "cabinets/MK.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "MVC" )
{
 local cab = fe.add_image( "cabinets/MVC.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "pacman" )
{
 local cab = fe.add_image( "cabinets/pacman.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "retropie" )
{
 local cab = fe.add_image( "cabinets/retropie.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "tmnt" )
{
 local cab = fe.add_image( "cabinets/tmnt.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "SNK" )
{
 local cab = fe.add_image( "cabinets/SNK.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "Capcom" )
{
 local cab = fe.add_image( "cabinets/Capcom.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "Data East" )
{
 local cab = fe.add_image( "cabinets/Data East.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "advMAME" )
{
 local cab = fe.add_image( "cabinets/advMAME.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "hacks" )
{
 local cab = fe.add_image( "cabinets/hacks.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "MAME4ALL" )
{
 local cab = fe.add_image( "cabinets/MAME4ALL.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "nintendo classics" )
{
 local cab = fe.add_image( "cabinets/nintendo classics.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "sega classics" )
{
 local cab = fe.add_image( "cabinets/sega classics.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "taito" )
{
 local cab = fe.add_image( "cabinets/taito.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "top 100" )
{
 local cab = fe.add_image( "cabinets/top 100.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "williams" )
{
 local cab = fe.add_image( "cabinets/williams.png", 0, 0, flw, flh );
}

if ( my_config["enable_cab"] == "atari classics" )
{
 local cab = fe.add_image( "cabinets/atari classics.png", 0, 0, flw, flh );
}


// Box art to dipslay, uses the emulator.cfg path for boxart image location
if ( my_config["enable_gboxart"] == "Yes" )
{
local boxart = fe.add_artwork("boxart", flx*0.06, fly*0.6 flw*0.1, flh*0.2 );
}

// Cartridge art to display, uses the emulator.cfg path for cartart for cartridge image location
if ( my_config["enable_gcartart"] == "Yes" )
{
local cartart = fe.add_artwork("cartart", flx*0.1, fly*0.68, flw*0.1, flh*0.1 );
}


// Adding in the SWF video files
if ( my_config["enable_gcartart"] == "Yes" )
{
//local swffile1 = fe.add_image("swfart/sonic1.swf", flx*0.3, fly*0.28, flw*0.2, flh*0.2 );
//local swffile2 = fe.add_image("swfart/sonic2.swf", flx*0.001, fly*0.001, flw*0.999, flh*0.999 );
local swffile3 = fe.add_image("swfart/sonic3.swf", flx*0.62, fly*0.06, flw*0.1, flh*0.1 );
local swffile4 = fe.add_image("swfart/RYU.KEN.swf", flx*0.34, fly*0.2, flw*0.1, flh*0.1 );
local swffile5 = fe.add_image("swfart/mushroom1.swf", flx*0.001, fly*0.8, flw*0.999, flh*0.3 );
}


// Clogo for adding system name artwork or diplay generic marquee
// remember to make both sections the same dimensions
// You can show or hide this entire image layer using the
// layout options.  Enable logo/marquee
if ( my_config["enable_logomarquee"] == "Yes" )
{

// Show the game marquee from the roms/xxx/marquee folder
// otherwise if not exist show default marquee.jpg
if ( my_config["enable_marquee"] == "marquee" )
{
local marquee = fe.add_artwork("marquee", flx*0.0937, fly*0.0575, flw*0.3283, flh*0.1192 );
 marquee.trigger = Transition.EndNavigation;
 marquee.skew_y = 0;
 marquee.skew_x = 0;
 marquee.pinch_x = 0;
 marquee.pinch_y = 0;
 marquee.rotation = 0;
   if ( my_config["enable_Lmarquee"] == "Yes" )
{
    local shader = fe.add_shader( Shader.Fragment "bloom_shader.frag" );
	shader.set_texture_param("bgl_RenderedTexture"); 
	marquee.shader = shader;
}

}
// Show the single logo in the clogos folder default.png
if ( my_config["enable_marquee"] == "logo" )
{
 local clogos = fe.add_image("clogos/default.png", flx*0.03, fly*0.03, flw*0.25, flh*0.25 );
 clogos.trigger = Transition.EndNavigation;
 clogos.skew_y = 0;
 clogos.skew_x = 0;
 clogos.pinch_x = 0;
 clogos.pinch_y = 0;
 clogos.rotation = 0;
}

// Show the emulator marquee in the clogos folder
if ( my_config["enable_marquee"] == "emulator" )
{
 local clogos = fe.add_image("clogos/[Emulator]", flx*0.0937, fly*0.0575, flw*0.3283, flh*0.1192 );
 clogos.trigger = Transition.EndNavigation;
 clogos.skew_y = 0;
 clogos.skew_x = 0;
 clogos.pinch_x = 0;
 clogos.pinch_y = 0;
 clogos.rotation = 0;
}

}

// The following section sets up what type and wheel and displays the users choice
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
local wheel_x = [ flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.68, flx*0.71, flx*0.71, flx*0.71, flx*0.71, flx*0.71, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.168,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
local wheel_r = [  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, ];
local num_arts = 8;

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
local wheel_x = [ flx*0.80, flx*0.795, flx*0.756, flx*0.725, flx*0.70, flx*0.68, flx*0.64, flx*0.68, flx*0.70, flx*0.725, flx*0.756, flx*0.76, ]; 
local wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
local wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.24, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
local wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
local wheel_h = [  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, flh*0.17,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11,  flh*0.11, ];
local wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
local num_arts = 8;

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

// The following sets up which pointer to show on the wheel
//property animation - wheel pointers
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
if ( my_config["enable_pointer"] == "default") 
{
local point = fe.add_image("pointers/default.png", flx*0.88, fly*0.34, flw*0.2, flh*0.35);

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


// Game information text box at bottom of screen
//add frame to make text standout 
if ( my_config["enable_frame"] == "Yes" )
{
local frame = fe.add_image( "frame.png", 0, fly*0.94, flw, flh*0.06 );
frame.alpha = 255;
}
// Game information to show inside text box frame
if ( my_config["enable_ginfo"] == "Yes" )
{
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
local mlogos = fe.add_image("mlogos/[Manufacturer]", flx*0.01, fly*0.945, flw*0.06, flh*0.05 );
mlogos.trigger = Transition.EndNavigation;
}		

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
