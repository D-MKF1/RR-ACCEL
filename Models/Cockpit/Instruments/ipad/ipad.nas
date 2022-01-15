var iPad_Vmax = nil;
var iPad_8nm = nil;
var iPad_300on3 = nil;
var iPad_Climb = nil;
var iPAD_display = nil;

var instrument_dir = "Aircraft/RR-ACCEL/Models/Cockpit/Instruments/ipad/";

var istart = props.globals.initNode("/electrical-flight-events/ipad/start",0,"BOOL");
var page = props.globals.initNode("/electrical-flight-events/ipad/page","start","STRING");

var vmaxstart = props.globals.initNode("/electrical-flight-events/vmax/vmax-start",0,"BOOL");
var vmaxalt = props.globals.initNode("/electrical-flight-events/vmax/vmax-alt",0,"DOUBLE");
for(var v=0; v < 9; v+=1){
	props.globals.initNode("/electrical-flight-events/vmax/vmax["~v~"]",0,"DOUBLE");
}

var vmaxOther = props.globals.getNode("/electrical-flight-events/vmax").getChildren("vmax");
var vmaxtrials = size(vmaxOther);
#print(vmaxtrials);

var canvas_iPAD_base = {
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

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		var starter = istart.getBoolValue();

		if ( starter == 1 ) {
			if(page.getValue() == "vmax"){
				iPad_Vmax.page.show();
				iPad_Vmax.update();
				iPad_8nm.page.hide();
				iPad_300on3.page.hide();
				iPad_Climb.page.hide();
			}elsif(page.getValue() == "300on3"){
				iPad_300on3.page.show();
				iPad_300on3.update();
				iPad_8nm.page.hide();
				iPad_Vmax.page.hide();
				iPad_Climb.page.hide();
			}elsif(page.getValue() == "8nm"){
				iPad_8nm.page.show();
				iPad_8nm.update();
				iPad_300on3.page.hide();
				iPad_Vmax.page.hide();
				iPad_Climb.page.hide();
			}elsif(page.getValue() == "climb"){
				iPad_Climb.page.show();
				iPad_Climb.update();
				iPad_8nm.page.hide();
				iPad_300on3.page.hide();
				iPad_Vmax.page.hide();
			}else{
				page.setValue("start");
				iPad_Vmax.page.hide();
				iPad_8nm.page.hide();
				iPad_300on3.page.hide();
				iPad_Climb.page.hide();
			}

		} else {
			iPad_Vmax.page.hide();
			iPad_8nm.page.hide();
			iPad_300on3.page.hide();
			iPad_Climb.page.hide();
		}

		settimer(func me.update(), 0.025);
	},
};


var canvas_iPAD_Vmax = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_iPAD_Vmax , canvas_iPAD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {



	}

};

var canvas_iPAD_8nm = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_iPAD_8nm , canvas_iPAD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {



	}

};

var canvas_iPAD_300on3 = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_iPAD_300on3 , canvas_iPAD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {



	}

};

var canvas_iPAD_Climb = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_iPAD_Climb , canvas_iPAD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return [];
	},
	update: func() {



	}

};


setlistener("sim/signals/fdm-initialized", func {
	iPAD_display = canvas.new({
		"name": "iPad",
		"size": [152, 202],    #in mm
		"view": [152, 202],		 #in mm
		"mipmapping": 1
	});
	iPAD_display.addPlacement({"node": "ipad.display"});
	var groupVmax = iPAD_display.createGroup();
	var group8nm = iPAD_display.createGroup();
	var group300on3 = iPAD_display.createGroup();
	var groupClimb = iPAD_display.createGroup();

	iPad_Vmax = canvas_iPAD_Vmax.new(groupVmax, instrument_dir~"vmax.svg");
	iPad_8nm = canvas_iPAD_8nm.new(group8nm, instrument_dir~"8nm.svg");
	iPad_300on3 = canvas_iPAD_300on3.new(group300on3, instrument_dir~"300on3.svg");
	iPad_Climb = canvas_iPAD_Climb.new(groupClimb, instrument_dir~"climb.svg");

	canvas_iPAD_base.update();
});


var startipad = func {
 	var ipw = getprop("/electrical-flight-events/ipad/start") or 0;
	var ipage = getprop("/electrical-flight-events/ipad/page") or "";
	if(ipw == 0){
		if(ipage == ""){
			setprop("/electrical-flight-events/ipad/page", "start");
		}
		setprop("/electrical-flight-events/ipad/start", 1);
	}elsif(ipw == 1 and ipage != "start"){
		setprop("/electrical-flight-events/ipad/page", "start");
	}else{
		setprop("/electrical-flight-events/ipad/start", 0);
	}
}
