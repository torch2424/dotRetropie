//
// OlRoom Theme (Mega Drive)
// Theme by Spinelli
// A huge thank you to the Ptiwee for doing the code
//

class UserConfig {
	</ label="Wheels Count", help="Number of slots in the wheel", order=1 />
	wheels="9";

	</ label="Spin Time", help="Time of a wheel transition (in milliseconds)", order=2 />
	spin_ms="200";
}

local config = fe.get_config();

local flw = fe.layout.width;
local flh = fe.layout.height;

//Background
local bg = fe.add_image("bg.jpg", 0, 0, flw, flh);

// Snap
local snap = fe.add_artwork("snap", flw*0.15, flh*0.26, flw*0.32, flh*0.43);
snap.trigger = Transition.EndNavigation;

// Flyer
local flyer = fe.add_artwork("flyer", flw*0.57, flh*0.53, flw*0.10, flh*0.37);
flyer.preserve_aspect_ratio = true;
flyer.trigger = Transition.EndNavigation;

// Title
local title = fe.add_text("[Title]", flw*0, flh*0.89, flw*0.4, flh*0.1);
title.align = Align.Left;
title.charsize = 40;
title.set_rgb(255, 255, 255);

// Playtime
local playtime = fe.add_text("Playtime : [PlayedTime]", flw*0.31, flh*0.89, flw*0.4, flh*0.1);
playtime.align = Align.Right;
playtime.charsize = 40;
playtime.set_rgb(255, 255, 255);

// Wheel

fe.load_module("conveyor");

local pi = 3.14;
local wheels = config["wheels"].tointeger() + 3;

class WheelEntry extends ConveyorSlot {
	constructor() {
		local w = fe.add_artwork("wheel");
		w.preserve_aspect_ratio = true;

		base.constructor(w);
	}

	function on_progress(progress, var) {
		/* Center alignment */
		local pos = abs(ceil(progress * wheels));
		local size, alpha;
		local pprogress = 1 - (pos.tofloat()/wheels - progress) * wheels;

		print(pos + " " + progress + " " + pprogress + "\n");
		size = 0.14;
		alpha = 155;

		if (pos == wheels/2 + 1) {
			size = 0.2 - pprogress * 0.06;
			alpha = 255 - pprogress * 100;
		} else if (pos == wheels/2) {
			size = 0.14 + pprogress * 0.06;
			alpha = 155 + pprogress * 100;
		}

		/* Realign between -2pi/3 and -4pi/3 */
		local angle = (progress * -2*pi/3) + 4*pi/3;

		m_obj.x = (1.4 - size /2)*flw + flh * cos(angle);
		m_obj.y = (0.5 - size /2)*flh + flh * sin(angle);

		m_obj.width = size*flw;
		m_obj.height = size*flh;

		m_obj.alpha = alpha;

		local rotation = (progress * -120) + 60;
		m_obj.rotation = rotation;
	}
};

local conveyor_bg = fe.add_text("", flw*0.73, flh*0, flw*0.28, flh*1);
conveyor_bg.set_bg_rgb(0,0,0);
conveyor_bg.bg_alpha = 220;

local slots = [];
for (local i=0; i<wheels; i++)
	slots.push(WheelEntry());

local conveyor = Conveyor();
conveyor.set_slots(slots);
conveyor.transition_ms = config["spin_ms"].tointeger();


