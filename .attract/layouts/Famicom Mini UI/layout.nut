///////////////////////////////////////////////////
//
// Attract-Mode Frontend - DAVBARC MINI NES LAYOUT
//
///////////////////////////////////////////////////

class UserConfig {
	</ label="Grid Artwork", help="The artwork to display in the grid", options="snap,marquee,flyer,wheel", order=1 />
	art="flyer";

	</ label="Entries", help="The number of entries to show for each filter", options="1,2,3,4,5,6,7,8", order=2 />
	entries="6";

	</ label="Filters", help="The number of filters to show", options="1,2,3,4,5,6,7,8", order=3 />
	filters="1";

	</ label="Flow Direction", help="Select the flow direction for entries", options="Horizontal,Vertical", order=4 />
	flow="Horizontal";

	</ label="Preserve Aspect Ratio", help="Preserve artwork aspect ratio", options="Yes,No", order=5 />
	aspect_ratio="Yes";

	</ label="Transition Time", help="The amount of time (in milliseconds) that it takes to scroll to another grid entry", order=6 />
	ttime="0";
}

function debug(msg) {
	::print(msg + "\n")
}

fe.layout.width = 1920;
fe.layout.height = 1080;

dofile(fe.script_dir +  "ui/conveyor_davbarc.nut");

fe.load_module( "animate");

local animate_overlay_in = {property = "y",start = 701,end = 350,pulse = false,time = 150,delay = 350,tween = Tween.Linear,loop = true,easing=Easing.Out};
local animate_overlay_infade = {property = "alpha",start = 0,end = 255,pulse = true,time = 150,delay = 50,tween = Tween.Linear,easing=Easing.Out};
local animate_overlay_out = {property = "y",start = 350,end = 701,pulse = false,time = 150,tween = Tween.Linear,easing=Easing.Out};
local animate_overlay_outfade = {property = "alpha",start = 255,end = 0,pulse = false,time = 150,delay = 350,tween = Tween.Linear,easing=Easing.Out};	
//debug("PATH: "+fe.script_dir);

local my_config = fe.get_config();

const TOP_SPACE = 30;
const BOTTOM_SPACE = 300;
const PAD = 50;
local sel_index = 1;
local x_dim;
local y_dim;
enum TState { None, Next, Prev };

local transition_state = TState.None;
local filters = [];
local f_labels = [];
local ftr_count = my_config["filters"].tointeger();
local ftr_index = ftr_count / 2;
local old_ftr_index = ftr_index;
local sel_count = my_config["entries"].tointeger();
local actualindex=sel_index;
local transition_ms = 150;
local submenu=false;
local submenuBig=false;
local SUBMENUNUMBER=1;
local boxswitch="";
local framexposition=null;
local menuleftright=null;
local boxcordvalue=null;
local bigmenuOpen=false;
local clone_strip_Gameback=null;
local Favorite_estate=false;
local timeframefav=100;
local wingstate=false;
local bgdefault=false;
local infofilt=true;
local stateinfofilt=false;
local stateinfofiltFix=false;
//FONDOS

local bg00 = fe.add_image( "systems/[DisplayName].png", 0, 0, 1920, 1080 ); //BACKGROUND 00 con lineas arriba y abajo
local bg02 = fe.add_image( "ui/bkg-02.png", 190, 225, 1539, 81 ); //BACKGROUND 02 INPUT TEXT
local bgicons = fe.add_image( "ui/bgicons.png", 672, 40, 0, 0 );  //FONDO DE LA APP

local hbtn=397;
local vbtn=895;
local fbtn=35;

local btnBase = fe.add_image( "ui/bkg-btn.png", hbtn, vbtn, 0, 0 ); //TEXTO START-SELECT BG
local btntext = fe.add_image( "ui/bkg-btn-text.png", hbtn, vbtn, 0, 0 ); //TEXTO START-SELECT
local btnUp=fe.add_text("Menu",hbtn+35,vbtn +3,200,fbtn);
local btnDown=fe.add_text("Extra info",hbtn+240,vbtn +3,200,fbtn);
local btnSelect=fe.add_text("Toggle Favorite",hbtn+558,vbtn +3,260,fbtn);
local btnStart=fe.add_text("Start Game",hbtn+920,vbtn +3,200,fbtn);

local displaynameDef=fe.add_text("[DisplayName]",0,950,1920,60);
displaynameDef.visible=false;
displaynameDef.set_rgb(255,255,255);
displaynameDef.font="joy"
//STRIPS
local strip_Gameback;
local strip_flyer;
local new_label;
local playerImg;

btnUp.align = Align.Left
btnDown.align = Align.Left
btnSelect.align = Align.Left
btnStart.align = Align.Left

local logo = fe.add_image("", fe.layout.width/2.7, fe.layout.height/ 28, fe.layout.width/3.9, fe.layout.height/7);
logo.trigger = Transition.EndNavigation;
logo.preserve_aspect_ratio =  "yes";

function favorito_state(){
return fe.game_info(Info.Favourite)
}
fe.add_transition_callback("transition_callback" );
//FONDOS FIN
	x_dim = fe.layout.width / sel_count+65; //espacio entre frame que selecciona 65ok
	y_dim = ( fe.layout.height - TOP_SPACE - BOTTOM_SPACE ) / ftr_count;

	for ( local i=0; i<ftr_count; i++ )
	{
		strip_Gameback = SimpleArtStripB("ui/gamefc.png",sel_count,-195,340,fe.layout.width+392,414,PAD-50 );
		strip_Gameback.transition_ms = transition_ms;
		strip_Gameback.set_selection( 0 );
		strip_Gameback.video_flags = Vid.NoAudio;
		strip_Gameback.preserve_aspect_ratio =  "yes";

		local temp = i - ftr_index;
		if ( temp != 0 )
		{
			strip_Gameback.filter_offset = temp;
			new_label.filter_offset = temp;
			strip_Gameback.enabled = false;
		}

		filters.push( strip_Gameback );
		f_labels.push( new_label );

	}


local framein = fe.add_image( "ui/selectboxin.png", 0, 20, 378, 414 ); //IMAGEN INTERNA DE LA CAJA
local snapswitch="flyer";

for ( local i=0; i<ftr_count; i++ )
{
	strip_flyer = SimpleArtStrip(snapswitch,sel_count,-194,336,fe.layout.width+390,348,46 );
	strip_flyer.transition_ms = transition_ms;
	strip_flyer.set_selection( 0 );
	strip_flyer.video_flags = Vid.NoAudio;
	strip_flyer.preserve_aspect_ratio = "yes";

	playerImg = SimpleArtStripB("ui/[Players]P.png",sel_count,-75,680,fe.layout.width+390,48,PAD-50 );		
	playerImg.set_selection( 0 );
	playerImg.video_flags = Vid.NoAudio;
	playerImg.preserve_aspect_ratio = "yes";
	playerImg.transition_ms = transition_ms;
}

local frame = fe.add_image( "ui/selectboxout.png", 0, 20, 379, 414 ); //IMAGEN EXTERNA DE LA CAJA
local bgicons = fe.add_image( "ui/icons.png", 672, 40, 576, 104 );  //FONDO DE LA APP
//STRIP MINI
local strip_Mini = SimpleArtStripMini( "flyer", 30, 210, 790, 1500, 70, 1 );
strip_Mini.transition_ms = transition_ms;
strip_Mini.set_selection( 12 );
strip_Mini.video_flags = Vid.NoAudio;
strip_Mini.preserve_aspect_ratio = "yes";

local animate_flyingwingsup = {when = Transition.StartLayout, property = "y",	start = 770,end = 745,pulse = false,loop=false,time = 1000,delay=0,tween = Tween.Linear,easing=Easing.Out,};
local animate_flyingwingsdown = {when = Transition.StartLayout, property = "y",start = 745,end = 770,pulse = false,time = 1000,loop=false,delay=1000,loop=true,tween = Tween.Linear,easing=Easing.Out,};
//sprite animation - use a spritesheet to animate specific frames of the sprite sheet

	local wingsfull = fe.add_image("ui/wingsfull.png", 60, 7612, 351, 261 );
	local wingscloud = fe.add_image("ui/cloud.png", 120, 720, 222, 285 );
	
	local snapwings = fe.add_artwork("snap", 145, 1245, 181, 136 );

	wingsfull.visible=true
	snapwings.visible=true
	wingscloud.visible=false
	local arrowsprite = fe.add_image("ui/arrow.png", 50, 50, 45, 28 );
	
function animWings(){
	if (wingstate==false)
	{
	wingsfull.visible=true
	snapwings.visible=true
	local animate_overlay_inX = {property = "y",start = 1200,end = 760,pulse = true,time = 500,delay = 150,tween = Tween.Linear,easing=Easing.Out};
	animation.add( PropertyAnimation( wingsfull, animate_overlay_inX ) );
	local animate_overlay_inXsnap = {property = "y",start = 1245,end = 805,pulse = true,time = 500,delay = 150,tween = Tween.Linear,easing=Easing.Out};
	animation.add( PropertyAnimation( snapwings, animate_overlay_inXsnap ) );
	wingstate=true;	
	}else{
	local animate_overlay_inX = {property = "y",start = 760,end = 1200,pulse = true,time = 1,delay = 1,tween = Tween.Linear,easing=Easing.Out};
	animation.add( PropertyAnimation( wingsfull, animate_overlay_inX ) );
	local animate_overlay_inXsnap = {property = "y",start = 805,end = 1245,pulse = true,time = 1,delay = 1,tween = Tween.Linear,easing=Easing.Out};
	animation.add( PropertyAnimation( snapwings, animate_overlay_inXsnap ) );	
	wingstate=false;
	actcloud()
	wingstate=false;
	}

}

	local sprite_cfg = {when = When.Always,width = 351,height=261,frame = 0,time = 4000,order = [ 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0 ],loop = true,}
	local sprite_cfg_cl = {when = When.Always,width = 222,height=285,frame = 4,time = 300,order = [ 0, 1, 2, 3, 4 ],loop = false,}
	
	animation.add( SpriteAnimation( wingsfull, sprite_cfg ) );
	function actcloud(){
		wingscloud.visible=true
		animation.add( SpriteAnimation( wingscloud, sprite_cfg_cl) );
	}

	
	local sprite_arrow = {when = When.Always,width = 46,height=27,frame = 0,time = 400,order = [ 0, 1, 2, 1],loop = true,}
	animation.add( SpriteAnimation( arrowsprite, sprite_arrow ) );

	//WINGS ANIMATION
	local textfilter = fe.add_text( "[FilterName]", 810, 150, 300, 40 );
	textfilter.font="joy";
	textfilter.visible=false;

	local infofilter_bubble=fe.add_image("ui/infofilter_bubble.png", 1930, 55, 0, 0 )
	local frame_texts = fe.add_text( "[FilterName] [ListEntry]/[ListSize]", 1930, 67, 445, 33 );
	frame_texts.font="joy";
	frame_texts.align = Align.Centre;

	function infofilter_toggle(){
		if (infofilt==true)
		{
			local animate_infofilter_bubble = {property = "x",start = 1920,end = 1450,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
			local animate_infofilter_bubbletext = {property = "x",start = 1920,end = 1470,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
			
			animation.add( PropertyAnimation( infofilter_bubble, animate_infofilter_bubble ) );
			animation.add( PropertyAnimation( frame_texts, animate_infofilter_bubbletext ) );
			infofilt=false;
		}else{
			local animate_infofilter_bubble = {property = "x",start = 1450,end = 1920,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
			local animate_infofilter_bubbletext = {property = "x",start = 1470,end = 1920,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};

			animation.add( PropertyAnimation( infofilter_bubble, animate_infofilter_bubble ) );
			animation.add( PropertyAnimation( frame_texts, animate_infofilter_bubbletext ) );

			infofilt=true;
		}
	}

	local name_label = fe.add_text( "[Title]", 0, 235, fe.layout.width, fe.layout.height / 20 );
	name_label.set_rgb (0,0,0);

	//favoritos
	local fav_bubble = fe.add_image( "ui/fav.png", 0, 0, 0, 0 ); //IMAGEN FAVORITOS
	fav_bubble.visible=false;
	local fav_bubble_texts_line1 = fe.add_text( "[Title]", 0, 0, 500, 35);
	local fav_bubble_texts_line2 = fe.add_text( "asdasd", 0, 0, 500, 28);
	fav_bubble_texts_line1.visible=false;
	fav_bubble_texts_line2.visible=false;	

	fav_bubble_texts_line1.set_rgb(0,0,0)
	fav_bubble_texts_line1.font="joy";
	fav_bubble_texts_line1.align = Align.Left;
	fav_bubble_texts_line1.word_wrap=false;

	fav_bubble_texts_line2.set_rgb(0,0,0)
	fav_bubble_texts_line2.font="joy";
	fav_bubble_texts_line2.align = Align.Left;

	//favoritos

function favorito_toggle(){
	bubbletog(true)
	strip_Gameback.transition_ms=0;
	strip_Mini.transition_ms=0;
	strip_flyer.transition_ms=0;
	playerImg.transition_ms=0;

	filters[ftr_index].enabled=false;
	fe.list.index += sel_index - filters[ftr_index].selection_index;

	foreach ( f in filters )
	f.set_selection( sel_index );
	actualindexfunc()
	//debug("transition_ms = "+transition_ms)
	hms()
	Favorite_estate=true;

	update_frame();
	filters[ftr_index].enabled=true;

	fe.signal("add_favourite");
	if (fe.game_info(Info.Favourite)!="1")
	{
	debug("AGREGADO a favoritos"+fe.game_info(Info.Favourite))
	fav_bubble_texts_line2.msg  = "ADDED TO FAVORITES";
		
	}else if(fe.game_info(Info.Favourite)=="1"){
		debug("QUITADO de favoritos"+fe.game_info(Info.Favourite))
		fav_bubble_texts_line2.msg  = "DELETED FROM FAVORITES"
	}
}

local bigmenuimg = fe.add_image("systems/[DisplayName]-menu.png",0,1080);
local textOverview = fe.add_text( "[Overview]", 90, 3970, 1300, 350 );

local totaltimeplayed = fe.add_text( "[!hms]", 1460, 1940, 300, 42 );
totaltimeplayed.font="joy" ;
totaltimeplayed.visible=true;
totaltimeplayed.set_rgb(100,100,100);

function hms(){
	local segstr=0;
	local segstr=fe.game_info(Info.PlayedTime,actualindex)

	local seg=0;
	seg=segstr.tofloat()
	
	local i=0
	local h=0
	local m=0
	local s=0

	for (i = 0; i < seg; ++i)
	{
		if (s<60)
		{
			s=s+1
		}else{
			s=0
			if (m<60){
				m++
			}else{
				m=0
				h++
			}

		}
	}

	if (h<10){h="0"+h}
	if (m<10){m="0"+m}
	if (s<10){s="0"+s}	

	local totaltime=h+":"+m+":"+s+" "+actualindex;
	totaltimeplayed.msg  = totaltime;
}

	function update_filters()
	{
		for ( local i=0; i<filters.len(); i++ )
		{
			foreach ( o in filters[i].m_objs )
			o.m_obj.rawset_filter_offset( i - ftr_index );

			f_labels[i].filter_offset = i - ftr_index;
		}

		foreach ( f in filters )
		f.enabled = false;
		filters[ftr_index].enabled = true;

		transition_state = TState.None;
		fe.list.filter_index += ftr_index - old_ftr_index;
		old_ftr_index = ftr_index;
	}

	function update_audio()
	{
		foreach ( f in filters )
		{
			foreach ( o in f.m_objs )
			o.m_obj.video_flags = Vid.NoAudio;
		}

		filters[ftr_index].m_objs[sel_index].m_obj.video_flags = 0;
	}
// Overall Surface
	local overlaySurface = fe.add_surface(800,243);
	overlaySurface.set_pos(0,701);
	overlaySurface.alpha = 0;	
	function update_frame()
	{
//FRAME IN
		framein.x = x_dim * sel_index - 190;
		framein.y = TOP_SPACE + y_dim * ftr_index+310;
		//FAV BUBBLE
		fav_bubble.x = x_dim * sel_index - 315;
		fav_bubble.y = 250;

		fav_bubble_texts_line1.x = x_dim * sel_index - 200;
		fav_bubble_texts_line1.y = 285;

		fav_bubble_texts_line2.x = x_dim * sel_index - 195;
		fav_bubble_texts_line2.y = 325;
		
hms()

//FRAME OUT
		frame.x = x_dim * sel_index - 189;
		frame.y = TOP_SPACE + y_dim * ftr_index+310;

		if (submenu==false)
		{
			if (boxswitch=="left"){framexposition=frame.x+385}
			if (boxswitch=="right"){framexposition=frame.x-385}

		if (Favorite_estate==true)
		{
			timeframefav=1;
			Favorite_estate=false;
		}else{
			timeframefav=100;
		}
			local animate_overlay_inX = {property = "x",start = framexposition,end = frame.x,pulse = false,time = timeframefav,delay = 50,tween = Tween.Linear,easing=Easing.Out};
			animation.add( PropertyAnimation( frame, animate_overlay_inX ) );

		}
//POS FLECHA
		arrowsprite.x = 829 + sel_index*47.5;
		arrowsprite.y = TOP_SPACE + y_dim * ftr_index+730;

		frame_texts.filter_offset

		= name_label.filter_offset
		= filters[ftr_index].m_objs[0].m_obj.filter_offset;

		frame_texts.index_offset
		= textOverview.index_offset
		= totaltimeplayed.index_offset
		= snapwings.index_offset
		= name_label.index_offset
		= sel_index - filters[ftr_index].selection_index;

		update_audio();
	}

	update_frame();
	function actualindexfunc(){
		strip_Gameback.set_selection( actualindex );
		strip_flyer.set_selection( actualindex );
		playerImg.set_selection( actualindex );
		strip_Mini.set_selection( 12+actualindex );

		strip_Gameback.transition_ms=transition_ms;
		strip_Mini.transition_ms=transition_ms;
		strip_flyer.transition_ms=transition_ms;
		playerImg.transition_ms=transition_ms;

	}
	fe.add_signal_handler( "on_signal" );

function boxcord(){
	if (sel_index==1){boxcordvalue=200}
	if (sel_index==2){boxcordvalue=585}
	if (sel_index==3){boxcordvalue=970}
	if (sel_index==4){boxcordvalue=1355}
}

function bubbletog(s){
	fav_bubble.visible=s;
	fav_bubble_texts_line1.visible=s;
	fav_bubble_texts_line2.visible=s;	
}


function moveupcursor(){
	boxcord()
	frame.file_name = "ui/selectboxmini.png";
	local animate_overlay_in_minibox = {property = "y",start = 400,end = 40,time = 150,delay = 0,tween = Tween.Linear,easing=Easing.Out};
	local animate_overlay_in_minibox_w = {property = "width",start = 378,end = 130,time = 150,delay = 0,tween = Tween.Linear,easing=Easing.Out};
	local animate_overlay_in_minibox_h = {property = "height",start = 414,end = 100,time = 150,delay = 0,tween = Tween.Linear,easing=Easing.Out};

	//framein.visible=false;
	animation.add( PropertyAnimation( frame, animate_overlay_in_minibox_h ) );
	animation.add( PropertyAnimation( frame, animate_overlay_in_minibox_w ) );
	animation.add( PropertyAnimation( frame, animate_overlay_in_minibox ) );	

}
function moveDowncursor(){
	frame.file_name = "ui/selectboxout.png";
	btnDown.x=637

		btnUp.msg="Menu"
		btnDown.msg="Extra info"
		btnSelect.msg="Toggle Favorite"
		btnStart.msg="Start Game"
		btnBase.file_name="ui/bkg-btn.png";
		btntext.file_name="ui/bkg-btn-text.png";

	local animate_overlay_in_mibox_w = {property = "width",start = 230,end = 378,time = 150,delay = 100,tween = Tween.Linear,easing=Easing.Out};
	local animate_overlay_in_mibox_h = {property = "height",start = 300,end = 414,time = 150,delay = 100,tween = Tween.Linear,easing=Easing.Out};
	animation.add( PropertyAnimation( frame, animate_overlay_in_mibox_w ) );
	animation.add( PropertyAnimation( frame, animate_overlay_in_mibox_h ) );
}


local snapwingsclone = fe.add_clone( snapwings);
snapwingsclone.x=1434;
snapwingsclone.width=327;
snapwingsclone.height=306;

textOverview.set_rgb(0,0,0);
textOverview.word_wrap=true;
textOverview.charsize =20;
textOverview.font="joy"
textOverview.height=200;
textOverview.align=Align.Left;

local wheelbigmenu = fe.add_image("",780,970,0,0);

function bigmenu(){
	if (bigmenuOpen==false)
	{
		//debug("big menu click if "+bigmenuOpen)
		bigmenuimg.visible=true;
		bigmenuOpen=true;

		local animate_bigmenuimg_up = {property = "y",start = 1080,end = 515,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_snapbigmenu_up = {property = "y",start = 1280,end = 670,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_textOverview = {property = "y",start = 1280,end = 670,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_wheelbigmenu = {property = "y",start = 1280,end = 580,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_totaltimeplayed = {property = "y",start = 1280,end = 975,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};

		animation.add( PropertyAnimation( bigmenuimg, animate_bigmenuimg_up ) );
		animation.add( PropertyAnimation( snapwingsclone, animate_snapbigmenu_up ) );
		animation.add( PropertyAnimation( textOverview, animate_textOverview ) );
		animation.add( PropertyAnimation( totaltimeplayed, animate_totaltimeplayed) );
	}else{
		//debug("big menu click else "+bigmenuOpen)
		bigmenuOpen=false
		local animate_bigmenuimg_up = {property = "y",start = 550,end = 1080,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_snapbigmenu_up = {property = "y",start = 670,end = 1280,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_textOverview = {property = "y",start = 670,end = 1280,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_wheelbigmenu = {property = "y",start = 1280,end = 670,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};
		local animate_totaltimeplayed = {property = "y",start = 975,end = 1280,time = 300,delay = 0,tween = Tween.Linear,easing=Easing.Out};

		animation.add( PropertyAnimation( bigmenuimg, animate_bigmenuimg_up ) );
		animation.add( PropertyAnimation( snapwingsclone, animate_snapbigmenu_up ) );
		animation.add( PropertyAnimation( textOverview, animate_textOverview ) );
		animation.add( PropertyAnimation( totaltimeplayed, animate_totaltimeplayed) );
	}
}
	local submenu_bubble = fe.add_image( "ui/submenu_bubble.png", 0, 140, 0, 0 ); //IMAGEN FAVORITOS
	submenu_bubble.visible=false;
	local submenu_bubble_text=fe.add_text("Menu",0,170,260,40);
	submenu_bubble_text.set_rgb(0,0,0);
	submenu_bubble_text.align = Align.Centre;
	submenu_bubble_text.visible=false;


function submenuposition(){
	//debug("SUBMENUNUMBER "+SUBMENUNUMBER)
	submenu_bubble_text.visible=true;
	submenu_bubble.visible=true;
	
	btnDown.x=740
	btnBase.file_name="ui/bkg-btntog.png";
	btntext.file_name="ui/bkg-btn-texttog.png";

	if (SUBMENUNUMBER==1){frame.x = 680;
		submenu_bubble.x = 615;
		submenu_bubble_text.x = 615;
		submenu_bubble_text.msg  = "Systems"
		btnUp.msg="Game List"
		btnDown.msg="Menu"
		btnSelect.msg="Previous System"
		btnStart.msg="Next System";
		if (stateinfofiltFix==false)
		{
			if (infofilt==false)
			{
			stateinfofilt=false;
			infofilter_toggle()
			}
		}
		
	}
	if (SUBMENUNUMBER==2){frame.x = 825;
		submenu_bubble.x = 760;
		submenu_bubble_text.x = 760;
		submenu_bubble_text.msg  = "Config"
		btnUp.msg="Game List"
		btnDown.msg="Configure"
		btnSelect.msg="---"
		btnStart.msg="---"
		if (stateinfofiltFix==false)
		{
			if (infofilt==false)
			{
			stateinfofilt=false;
			infofilter_toggle()
			}
		}
	}
	if (SUBMENUNUMBER==3){frame.x = 970;
		submenu_bubble.x = 905;
		submenu_bubble_text.x = 905;
		submenu_bubble_text.msg  = "Filters"
		btnUp.msg="Game List"
		btnDown.msg="Menu"
		btnSelect.msg="Previous Filter"
		btnStart.msg="Next Filter";
		if (stateinfofiltFix==false)
		{
		infofilt=true;
		stateinfofilt=true;
		infofilter_toggle()
		}
	}
	if (SUBMENUNUMBER==4){frame.x = 1110;
		submenu_bubble.x = 1045;
		submenu_bubble_text.x = 1045;
		submenu_bubble_text.msg  = "Mini snap"
		btnUp.msg="Game List"
		btnDown.msg="Last game"
		btnSelect.msg="Toggle Snap"
		btnStart.msg="Filter info";
		if (stateinfofiltFix==false)
		{
			if (infofilt==false)
			{
			stateinfofilt=false;
			infofilter_toggle()
			}
		}
	}

	if (boxswitch=="left"){menuleftright=frame.x+145}
	if (boxswitch=="right"){menuleftright=frame.x-145}

	local animate_overlay_in_minibox = {property = "x",start = menuleftright,end = frame.x,time = 100,delay = 0,tween = Tween.Linear,loop = true,easing=Easing.Out};
	animation.add( PropertyAnimation( frame, animate_overlay_in_minibox ) );
	frame.width=130;
	frame.height=104;

}

	function on_signal( sig )
	{

		local frameXrestore=frame.x;
		local frameYrestore=frame.y;
		local frameWrestore=frame.width;
		local frameHrestore=frame.height;

		switch ( sig )
		{

			case "up":
			bubbletog(false)
			if (bigmenuOpen==true)
			{
				bigmenu()
			}else{

				if (submenu==false)
				{
				submenu=true;
				//debug("press up - sel_index:"+sel_index)
				submenuposition()
				moveupcursor()
				}
			}
			break;

			case "down":
			//debug("press down - submenu state:"+submenu)
			bubbletog(false)
			submenu_bubble_text.visible=false;
			submenu_bubble.visible=false;

			if (submenu==true)
			{
				submenu=false;
				frame.x = frameXrestore;
				frame.y = frameYrestore;
				update_frame()
				moveDowncursor()

			framein.visible=true;
			if (stateinfofilt==true)
			{
			stateinfofilt=false;
			infofilter_toggle()
			}

			}else{
				if (bigmenuOpen==false)
				{
				bigmenu()
				}
			}

			break;	
			case "left":

			bubbletog(false)
			framein.alpha=0;
				boxswitch="left";
			if (submenu==false)
			{
				if ( sel_index > 1 )
				{
					sel_index--;
					actualindex=sel_index
					local animate_overlay_framein = {property = "alpha",start = 0,end = 255,pulse = false,time = 500,delay = 0,tween = Tween.Linear,easing=Easing.Out};
					animation.add( PropertyAnimation( framein, animate_overlay_framein ) );
					update_frame();
				}
				else
				{
					fe.signal( "prev_game" );
					actualindex=sel_index
					framein.alpha=255;
					update_frame()
				}
				//debug("FRAMEX L= "+frame.x+" Y "+frame.y)
			}else{
				if (SUBMENUNUMBER>1)
				{
					SUBMENUNUMBER--;
					submenuposition()
					//debug("FRAMEX L= "+frame.x+" Y "+frame.y)
				}
			}

			return true;
			case "right":
			bubbletog(false)
				boxswitch="right";
			if (submenu==false)
			{
				if ( sel_index < sel_count - 2 )
				{
					sel_index++;
					update_frame();
					actualindex=sel_index
					local animate_overlay_framein = {property = "alpha",start = 0,end = 255,pulse = false,time = 500,delay = 0,tween = Tween.Linear,easing=Easing.Out};
					animation.add( PropertyAnimation( framein, animate_overlay_framein ) );
					hms()
				}
				else
				{
					fe.signal( "next_game" );
					actualindex=sel_index
					update_frame()
				}
			//debug("FRAMEX R= "+frame.x+" Y "+frame.y)
			}else{
				if (SUBMENUNUMBER<4)
				{
					SUBMENUNUMBER++;
					submenuposition()
					//debug("FRAMEX R= "+frame.x+" Y "+frame.y)
				}
			}
			return true;

			case "next_game":

			break;
			case "prev_game":

			break;
			case "next_filter":
			case "prev_filter":
			case "exit":
			case "exit_no_menu":
			break;

   case "replay_last_game":
   	
   break;

case "custom6":
actcloud()
break;

   case "custom1": //BUTTON B
   		if (submenu==true){
		if (SUBMENUNUMBER==1)
		{
			fe.signal("prev_display")
			//debug("DENTRO DE CUSTOM3, IF 1 next_list")
			break;
		}
		if (SUBMENUNUMBER==2)
		{
			//debug("DENTRO DE CUSTOM3, IF 2")
			break;
		}
		if (SUBMENUNUMBER==3)
		{
			fe.signal("prev_filter")
			//debug("DENTRO DE CUSTOM3, IF 3")
			break;
		}
		if (SUBMENUNUMBER==4)
		{
			animWings()
			//debug("DENTRO DE CUSTOM3, IF 4"+mmm)
			break;
		}
	}else{
		//fe.signal("prev_letter")
	}
   break;
   case "custom2": //BUTTON A
   		if (submenu==true){
		if (SUBMENUNUMBER==1)
		{
			fe.signal("next_display")
			//debug("DENTRO DE CUSTOM3, IF 1 next_list")
			break;
		}
		if (SUBMENUNUMBER==2)
		{
			//debug("DENTRO DE CUSTOM3, IF 2")
			break;
		}
		if (SUBMENUNUMBER==3)
		{
			fe.signal("next_filter")
			//debug("DENTRO DE CUSTOM3, IF 3")
			break;
		}
		if (SUBMENUNUMBER==4)
		{
			if (stateinfofiltFix==false)
			{
				stateinfofiltFix=true
				infofilter_toggle()
			}else{
				stateinfofiltFix=false
				infofilter_toggle()
			}
			//debug("DENTRO DE CUSTOM3, IF 4"+mmm)
			break;
		}
	}else{
		//fe.signal("next_letter")
	}
   break;
   case "custom4": //BUTTON TESTING
		infofilter_toggle()
   break;

	case "custom3": // BUTTON SELECT
	if (submenu==true){
		if (SUBMENUNUMBER==1)
		{
			fe.signal("displays_menu")
			//debug("DENTRO DE CUSTOM3, IF 1 next_list")
			break;
		}
		if (SUBMENUNUMBER==2)
		{
			fe.signal("configure")
			//debug("DENTRO DE CUSTOM3, IF 2")
			break;
		}
		if (SUBMENUNUMBER==3)
		{
			fe.signal("filters_menu")
			//debug("DENTRO DE CUSTOM3, IF 3")
			break;
		}
		if (SUBMENUNUMBER==4)
		{
			animWings()

			//debug("DENTRO DE CUSTOM3, IF 4"+mmm)
			break;
		}
	}else{
		favorito_toggle()
	}

	break;
	case "select":


	strip_Gameback.transition_ms=0;
	strip_Mini.transition_ms=0;
	strip_flyer.transition_ms=0;
	playerImg.transition_ms=0;

	filters[ftr_index].enabled=false;
	fe.list.index += sel_index - filters[ftr_index].selection_index;

	foreach ( f in filters )
	f.set_selection( sel_index );
	actualindexfunc()
	//debug("transition_ms = "+transition_ms)

	update_frame();
	filters[ftr_index].enabled=true;
	break;
}

return false;
}

function principalmenupos(){
clone_strip_Gameback=fe.add_clone() //check

	local animate_strip_Gameback = {property = "y",start = 225,end = 150,pulse = false,time = 100,delay = 50,tween = Tween.Linear,easing=Easing.Out};
	local animate_principalmenuWhiteinput = {property = "y",start = 225,end = 150,pulse = false,time = 100,delay = 50,tween = Tween.Linear,easing=Easing.Out};
	
	animation.add( PropertyAnimation( bg02, animate_principalmenuWhiteinput ) );
	animation.add( PropertyAnimation( clone_strip_Gameback, animate_strip_Gameback ) );

}

function shownamesystem(r,g,b,v){
	local systemnametext = fe.add_text( "[SystemN]", 0, 940, 1920, 70 );
	systemnametext.font="joy";
	systemnametext.align = Align.Centre;
	systemnametext.set_rgb (r,g,b);
	logo.visible=v;
	systemnametext.visible=v;
	debug(systemnametext.visible+" systemnametext: "+systemnametext)
}
function bgdefaultfunc(valorbool){
local listnameemu= fe.list.name;
if (valorbool==true)
{
	bigmenuimg.file_name="systems/default-menu.png";
	bg00.file_name="systems/default.png";
	bgdefault=true;
	displaynameDef.visible=true;
}else{
	bigmenuimg.file_name="systems/"+listnameemu+"-menu.png";
	bg00.file_name="systems/"+listnameemu+".png";
	bgdefault=false;
	displaynameDef.visible=false;
}
debug("systems/"+listnameemu+".png "+bg00.file_name)
}

function transition_callback(ttype, var, ttime)
{

if (bgdefault==true)
	{
		bigmenuimg.file_name="systems/default-menu.png";
		bg00.file_name="systems/default.png";
	}
	switch ( ttype )
	{
		case Transition.FromOldSelection:
		//debug("FromOldSelection")
		hms()
		break;
		case Transition.ToNewList:
		switch ( fe.list.name )
		{          
			case "Playstation":
			bgdefaultfunc(false)
			btnBase.set_rgb(50,109,179);
			btnUp.set_rgb(50,109,179);
			btnDown.set_rgb(50,109,179);
			btnSelect.set_rgb(50,109,179);
			btnStart.set_rgb(50,109,179);
			
			textfilter.set_rgb(222,0,41);		
			frame_texts.set_rgb(222,0,41);

			frame.set_rgb(0,170,158); //COLOR MARCO
			framein.set_rgb(0,170,158); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(243,194,2); //COLOR FLECHA 243,194,2
			break;
			case "snes":
			bgdefaultfunc(false)
			btnBase.set_rgb(72,56,129)
			btnUp.set_rgb(72,56,129)
			btnDown.set_rgb(72,56,129)
			btnSelect.set_rgb(72,56,129)
			btnStart.set_rgb(72,56,129)
			
			textfilter.set_rgb(172,168,218);		
			frame_texts.set_rgb(172,168,218);

			frame.set_rgb(72,56,129); //COLOR MARCO
			framein.set_rgb(72,56,129); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(172,168,218);; //COLOR FLECHA

			break;
			case "famicom":
			bgdefaultfunc(false)
			//colors
	
			btnUp.set_rgb(154,0,0)
			btnDown.set_rgb(154,0,0)
			btnSelect.set_rgb(154,0,0)
			btnStart.set_rgb(154,0,0)
			btnBase.set_rgb(154,0,0)

			textfilter.set_rgb(154,0,0);
			frame_texts.set_rgb(154,0,0);

			frame.set_rgb(52,253,253); //COLOR MARCO
			framein.set_rgb(0,121,240); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(65,210,254); //COLOR FLECHA

			break;
			case "Game Boy":
			bgdefaultfunc(false)
			//colors
	
			btnUp.set_rgb(174,15,97)
			btnDown.set_rgb(174,15,97)
			btnSelect.set_rgb(174,15,97)
			btnStart.set_rgb(174,15,97)
			btnBase.set_rgb(174,15,97)

			textfilter.set_rgb(33,33,33);
			frame_texts.set_rgb(33,33,33);

			frame.set_rgb(202, 207, 104); //COLOR MARCO
			framein.set_rgb(159, 179, 2); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(202, 207, 104); //COLOR FLECHA
			textOverview.set_rgb(33,33,33);
			
			break;
			case "Sega Genesis":
			bgdefaultfunc(false)

			btnUp.set_rgb(19,78,156)
			btnDown.set_rgb(19,78,156)
			btnSelect.set_rgb(19,78,156)
			btnStart.set_rgb(19,78,156)
			btnBase.set_rgb(19,78,156)

			textfilter.set_rgb(209,209,209);
			frame_texts.set_rgb(209,209,209);

			frame.set_rgb(19,78,156); //COLOR MARCO
			framein.set_rgb(0,121,240); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(255,0,0); //COLOR FLECHA
			textOverview.set_rgb(209,209,209);
			break; 
			default:
			bgdefault=true;
			bgdefaultfunc(true)
			bigmenuimg.file_name="systems/default-menu.png";
			bg00.file_name="systems/default.png";
			//colors
	
			btnUp.set_rgb(154,0,0)
			btnDown.set_rgb(154,0,0)
			btnSelect.set_rgb(154,0,0)
			btnStart.set_rgb(154,0,0)
			btnBase.set_rgb(154,0,0)

			textfilter.set_rgb(154,0,0);
			frame_texts.set_rgb(154,0,0);

			frame.set_rgb(52,253,253); //COLOR MARCO
			framein.set_rgb(0,121,240); //COLOR MARCO INTERNO
			arrowsprite.set_rgb(1,1,254); //COLOR FLECHA
			break;
		}
		break;
	}
}