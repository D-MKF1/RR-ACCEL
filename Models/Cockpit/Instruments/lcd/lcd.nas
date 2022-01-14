# Test a canvas instrument

var LCD_main = nil;
var LCD_display = nil;

var LCDvolts = props.globals.getNode("systems/accel-electrical/battery/engine-volts", 1);
var start_prop = props.globals.getNode("systems/accel-electrical/start", 1);

var instrument_dir = "Aircraft/RR-ACCEL/Models/Cockpit/Instruments/lcd/";

var AI_pitch = props.globals.getNode("orientation/pitch-deg", 1);
var AI_roll = props.globals.getNode("orientation/roll-deg", 1);


var canvas_LCD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "../../../Fonts/monoMMM_5.ttf";
		};


		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

		 var svg_keys = me.getKeys();

		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var svg_keys = me.getKeys();
			foreach (var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();
				var clip_rect = sprintf("rect(%d,%d, %d,%d)",
				tran_rect[1], # 0 ys
				tran_rect[2], # 1 xe
				tran_rect[3], # 2 ye
				tran_rect[0]); #3 xs
				#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
			}
		}
    me.h_trans = me["horizon"].createTransform();
		me.h_rot = me["horizon"].createTransform();

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		var starter = start_prop.getBoolValue();

		if ( starter == 1 ) {
			LCD_main.page.show();
		} else {
			LCD_main.page.hide();
		}

		settimer(func me.update(), 0.02);
	},
};

var canvas_LCD_main = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_LCD_main , canvas_LCD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["horizon","lcd.hdg", "lcd.rpm", "lcd.rpm-prop", "lcd.hp", "lcd.kw"];
	},
	update: func() {

    #Attitude Indicator
    var pitch = AI_pitch.getValue();
    var roll =  AI_roll.getValue();
		var hdg = getprop("autopilot/settings/heading-bug-deg") or 0;
		var hp = getprop("systems/accel-electrical/fake-outputs/hp") or 0;
		var kw = getprop("systems/accel-electrical/fake-outputs/kw") or 0;
		var rpm_prop = getprop("systems/accel-electrical/fake-outputs/proppeller-rotation") or 0;
		var rpm = getprop("systems/accel-electrical/fake-outputs/engine-rpm") or 0;

    me.h_trans.setTranslation(0,pitch*3.36);
    me.h_rot.setRotation(-roll*D2R,me["horizon"].getCenter());

		me["lcd.hdg"].setText(sprintf("%3d", hdg));
		me["lcd.rpm"].setText(sprintf("%3d", rpm));
		me["lcd.rpm-prop"].setText(sprintf("%3d", rpm_prop));
		me["lcd.hp"].setText(sprintf("%3d", hp));
		me["lcd.kw"].setText(sprintf("%3d", kw));


		settimer(func me.update(), 0.02);
	}

};

setlistener("sim/signals/fdm-initialized", func {
	LCD_display = canvas.new({
		"name": "LCD",
		"size": [870, 470],
		"view": [870, 470],
		"mipmapping": 1
	});
	LCD_display.addPlacement({"node": "lcd.display"});
	var groupMain = LCD_display.createGroup();

	LCD_main = canvas_LCD_main.new(groupMain, instrument_dir~"LCD_main.svg");

	LCD_main.update();
	canvas_LCD_base.update();
});

var showLCD = func {
	var dlg = canvas.Window.new([330,165], "dialog").set("resize", 1);
	dlg.setCanvas(LCD_display);
}
