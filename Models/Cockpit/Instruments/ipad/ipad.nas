############### importand for the fdm-init setlistener at the end of this file ############
var iPad_Vmax = nil;
var iPad_8nm = nil;
var iPad_300on3 = nil;
var iPad_Climb = nil;
var iPAD_display = nil;

################ some inits  ##############
var instrument_dir = "Aircraft/RR-ACCEL/Models/Cockpit/Instruments/ipad/";

var istart = props.globals.initNode("/electrical-flight-events/ipad/start",0,"BOOL");
var page = props.globals.initNode("/electrical-flight-events/ipad/page","start","STRING");
var startevent = props.globals.initNode("/electrical-flight-events/start-event",0,"BOOL");
var startaltitude = props.globals.initNode("/electrical-flight-events/start-altitude",0,"DOUBLE");
var starthpa = props.globals.initNode("/electrical-flight-events/start-hpa",0,"DOUBLE");
var startwindfrom = props.globals.initNode("/electrical-flight-events/start-wind-from",0,"DOUBLE");
var startwindspeed = props.globals.initNode("/electrical-flight-events/start-wind-speed-kt",0,"DOUBLE");

var vmaxact = props.globals.initNode("/electrical-flight-events/vmax/vmax-actual",0,"DOUBLE");
for(var v=0; v <= 9; v+=1){
	props.globals.initNode("/electrical-flight-events/vmax/vmax["~v~"]",0,"DOUBLE");
	props.globals.initNode("/electrical-flight-events/vmax/vmax-string["~v~"]","","STRING");
}

############# the canvas base class - also switch for the actual shown canvas #################
var canvas_iPAD_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "../Fonts/CaviarDreams.ttf";
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

########## the possible views on screen, with the logic for the flight events ######################

var canvas_iPAD_Vmax = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_iPAD_Vmax , canvas_iPAD_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["vmax.digits","test.0","test.1","test.2","test.3","test.4","test.5","test.6","test.7","test.8","test.9","info.0","info.1","info.2","info.3","info.4","info.5","info.6","info.7","info.8","info.9"];
	},
	update: func() {

		var speed = getprop("instrumentation/airspeed-indicator/indicated-speed-kt") or 0;
		var vmax = vmaxact.getValue();
		var start = startevent.getValue();
		var startalt = startaltitude.getValue();
		var actalt = getprop("instrumentation/altimeter/indicated-altitude-ft") or 0;
		var hpa = getprop("instrumentation/altimeter/setting-hpa") or 0;
		var inhg = getprop("environment/pressure-inhg") or 0;
		var windkts = getprop("environment/wind-speed-kt") or 0;
		var windfrom = getprop("environment/wind-from-heading-deg") or 0;
		var pitchdeg = getprop("orientation/pitch-deg") or 0;
		var temp_c = getprop("environment/temperature-degc") or 0;
		var timestring =  getprop("time/gmt") or "";

		if(start == 1){
			if(startalt == 0){
				startaltitude.setValue(actalt);
				starthpa.setValue(hpa);
				startwindfrom.setValue(windfrom);
				startwindspeed.setValue(windkts);
			}

			# show last 10 tests
			var vmaxOther = props.globals.getNode("/electrical-flight-events/vmax").getChildren("vmax");
			var vmaxtrials = size(vmaxOther);
			var speedtest_list = {};

			for(var i=0; i < vmaxtrials; i+=1){
				me["test."~i].setText(sprintf("%.2f", getprop("/electrical-flight-events/vmax/vmax["~i~"]") or 0));
				me["info."~i].setText(sprintf("%s", getprop("/electrical-flight-events/vmax/vmax-string["~i~"]") or "-"));
			}

			# monitor the valid tests
			if(speed > vmax and pitchdeg >= -1.8 and actalt >= (startalt-100) and windkts <= 20){
				vmaxact.setValue(speed);
				me["vmax.digits"].setText(sprintf("%.2f", speed));
			}

		}else{

			# test is finished, but the last vamx isn't deleted - that's the right point to save this test.
			if(vmaxact.getValue() != 0){

				# sort the last 10 speedtests
				var vmaxOther = props.globals.getNode("/electrical-flight-events/vmax").getChildren("vmax");
				var vmaxtrials = size(vmaxOther);
				var speedtest_list = {};
				for(var i=0; i < vmaxtrials; i+=1){
					speedtest_list[i] = {s: getprop("/electrical-flight-events/vmax/vmax["~i~"]"),e: getprop("/electrical-flight-events/vmax/vmax-string["~i~"]")};
				}

				# write the info text for this speedtest
				var infotext = "kts  "~sprintf("%.0f", actalt)~"ft/ "~sprintf("%.2f", inhg)~"/ "~sprintf("%.1f", temp_c)~"°C/ Wind "~sprintf("%.0f", windkts)~"kts/ "~timestring;
				speedtest_list[10] = {s: vmaxact.getValue(), e: infotext}; # fill the hash with the actual test

				var sortedspeedtest_list = sort(keys(speedtest_list), func (a,b) { speedtest_list[b].s - speedtest_list[a].s;});
				pop(sortedspeedtest_list);  #cut the slowest test
				var sortnr = size(sortedspeedtest_list);

				if(sortedspeedtest_list != nil){
					for(var n=0; n < sortnr; n+=1){
						me["test."~n].setText(sprintf("%.2f", speedtest_list[sortedspeedtest_list[n]].s));
						setprop("/electrical-flight-events/vmax/vmax["~n~"]", speedtest_list[sortedspeedtest_list[n]].s);
						setprop("/electrical-flight-events/vmax/vmax-string["~n~"]", speedtest_list[sortedspeedtest_list[n]].e);
					}
				}
				me["vmax.digits"].setText(sprintf("%.2f", vmaxact.getValue()));
			}else{

				# show last 10 tests
				var vmaxOther = props.globals.getNode("/electrical-flight-events/vmax").getChildren("vmax");
				var vmaxtrials = size(vmaxOther);
				for(var i=0; i < vmaxtrials; i+=1){
					me["test."~i].setText(sprintf("%.2f", getprop("/electrical-flight-events/vmax/vmax["~i~"]") or 0));
					me["info."~i].setText(sprintf("%s", getprop("/electrical-flight-events/vmax/vmax-string["~i~"]") or "-"));
				}

			}

			vmaxact.setValue(0.0);
			startaltitude.setValue(0.0);
			starthpa.setValue(0.0);
			startwindfrom.setValue(0.0);
			startwindspeed.setValue(0.0);
		}

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

############ the init setlistener #################

setlistener("sim/signals/fdm-initialized", func {
	iPAD_display = canvas.new({
		"name": "iPad",
		"size": [456, 606],    #in mm
		"view": [456, 606],		 #in mm
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


#########  stuff for the click action on the ipad ###########

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

################ functions ##############
var sort_rules = func(a, b){
    if(a < b){
        return -1; # a should before b in the returned vector
    }elsif(a == b){
        return 0; # a is equivalent to b
    }else{
        return 1; # a should after b in the returned vector
    }
}
