# Test a canvas instrument

var DDU10_main = nil;
var DDU10_display = nil;

var DDU10 = props.globals.getNode("systems/accel-electrical/battery/engine-volts", 1);
var start_prop = props.globals.getNode("systems/accel-electrical/startsys", 1);
var rest_time = props.globals.getNode("systems/accel-electrical/battery/crh", 1);

var instrument_dir = "Aircraft/RR-ACCEL/Models/Cockpit/Instruments/ddu10/";

var rand1 = 0.0;
var rand2 = 0.0;
var rand3 = 0.0;
var rand4 = 0.0;
var rand5 = 0.0;
var rand6 = 0.0;

while (rand1 < 0.5 or rand1 > 0.6) {
    rand1 = rand();
}
while (rand2 < 0.5 or rand2 > 0.6) {
    rand2 = rand();
}
while (rand3 < 0.5 or rand3 > 0.6) {
    rand3 = rand();
}
while (rand4 < 0.3 or rand4 > 0.7) {
    rand4 = rand();
}
while (rand5 < 0.3 or rand5 > 0.7) {
    rand5 = rand();
}

var pluscalcfact = (3-(rand1 + rand2 + rand3))/3;
var pluscalcfactfine = (2-(rand4 + rand5))/2;

var charge_cell_1 = props.globals.getNode("/systems/accel-electrical/battery/battery-charge-percent", 1);
var charge_cell_2 = props.globals.getNode("/systems/accel-electrical/battery/battery-charge-percent", 1);
var charge_cell_3 = props.globals.getNode("/systems/accel-electrical/battery/battery-charge-percent", 1);


var canvas_DDU10_base = {
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
		var starter = start_prop.getBoolValue();

		if ( starter > 0.98 ) {
			DDU10_main.page.show();
		} else {
			DDU10_main.page.hide();
		}

    var wgpu = getprop("aircraft/settings/weak_gpu") or 0;
		if(wgpu == 0){
			settimer(func me.update(), 0.02);
		}
	},
};

var canvas_DDU10_main = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_DDU10_main , canvas_DDU10_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["ddu10.volts","ddu10.cell.1","ddu10.cell.2","ddu10.cell.3",
            "c1.b1","c1.b2","c1.b3","c1.b4","c1.b5","c1.b6","c2.b1","c2.b2","c2.b3","c2.b4","c2.b5","c2.b6","c3.b1","c3.b2","c3.b3","c3.b4","c3.b5","c3.b6",
            "text.c1b1","text.c1b2","text.c1b3",
            "text.c2b1","text.c2b2","text.c2b3",
            "text.c3b1","text.c3b2","text.c3b3",
            "ddu10.kw","bg.kw","rest.hour","rest.min", "rest.sec"];
	},
	update: func() {

		# Calc the rest time
    var rm = rest_time.getValue();
    var s = rm*3600;
    var hours = int(s / 3600);
    var minutes = int(math.mod(s / 60, 60));
    var seconds = int(math.mod(s, 60));

    #Voltage Power
		var DDU10_val = DDU10.getValue();
		var chrc1 = charge_cell_1.getValue()*(rand1+pluscalcfact);
		var chrc2 = charge_cell_2.getValue()*(rand2+pluscalcfact);
		var chrc3 = charge_cell_3.getValue()*(rand3+pluscalcfact);

    me["rest.hour"].setText(sprintf("%2d", hours));
    me["rest.min"].setText(sprintf("%2d", minutes));
    me["rest.sec"].setText(sprintf("%2d", seconds));

		me["ddu10.volts"].setText(sprintf("%4d", math.round(DDU10_val)));
		me["ddu10.cell.1"].setText(sprintf("%3d", math.round(chrc1*100)));
		me["ddu10.cell.2"].setText(sprintf("%3d", math.round(chrc2*100)));
		me["ddu10.cell.3"].setText(sprintf("%3d", math.round(chrc3*100)));

		# only diffuse calculation to show not the same charge param for every block and cell - nothing
    var tc1b1 = chrc1*(rand1+pluscalcfact);
    var tc1b2 = chrc1*(rand3+pluscalcfact);
    var tc1b3 = chrc1*(rand2+pluscalcfact);

    var tc2b1 = chrc2*(rand3+pluscalcfact);
    var tc2b2 = chrc2*(rand2+pluscalcfact);
    var tc2b3 = chrc2*(rand1+pluscalcfact);

    var tc3b1 = chrc3*(rand2+pluscalcfact);
    var tc3b2 = chrc3*(rand1+pluscalcfact);
    var tc3b3 = chrc3*(rand3+pluscalcfact);

    me["text.c1b1"].setText(sprintf("%3d", math.round(tc1b1*100)));
    me["text.c1b2"].setText(sprintf("%3d", math.round(tc1b2*100)));
    me["text.c1b3"].setText(sprintf("%3d", math.round(tc1b3*100)));

    me["text.c2b1"].setText(sprintf("%3d", math.round(tc2b1*100)));
    me["text.c2b2"].setText(sprintf("%3d", math.round(tc2b2*100)));
    me["text.c2b3"].setText(sprintf("%3d", math.round(tc2b3*100)));

    me["text.c3b1"].setText(sprintf("%3d", math.round(tc3b1*100)));
    me["text.c3b2"].setText(sprintf("%3d", math.round(tc3b2*100)));
    me["text.c3b3"].setText(sprintf("%3d", math.round(tc3b3*100)));

    # diagramm
    me["c1.b1"].setTranslation(0,(1-tc1b1)*200*(rand4+pluscalcfactfine));
		me["c1.b2"].setTranslation(0,(1-tc1b1)*200*(rand5+pluscalcfactfine));
		me["c1.b3"].setTranslation(0,(1-tc1b2)*200*(rand5+pluscalcfactfine));
		me["c1.b4"].setTranslation(0,(1-tc1b2)*200*(rand4+pluscalcfactfine));
		me["c1.b5"].setTranslation(0,(1-tc1b3)*200*(rand5+pluscalcfactfine));
		me["c1.b6"].setTranslation(0,(1-tc1b3)*200*(rand4+pluscalcfactfine));

		me["c2.b1"].setTranslation(0,(1-tc2b1)*200*(rand5+pluscalcfactfine));
		me["c2.b2"].setTranslation(0,(1-tc2b1)*200*(rand4+pluscalcfactfine));
		me["c2.b3"].setTranslation(0,(1-tc2b2)*200*(rand4+pluscalcfactfine));
		me["c2.b4"].setTranslation(0,(1-tc2b2)*200*(rand5+pluscalcfactfine));
		me["c2.b5"].setTranslation(0,(1-tc2b3)*200*(rand5+pluscalcfactfine));
		me["c2.b6"].setTranslation(0,(1-tc2b3)*200*(rand4+pluscalcfactfine));

		me["c3.b1"].setTranslation(0,(1-tc3b1)*200*(rand4+pluscalcfactfine));
		me["c3.b2"].setTranslation(0,(1-tc3b1)*200*(rand5+pluscalcfactfine));
		me["c3.b3"].setTranslation(0,(1-tc3b2)*200*(rand4+pluscalcfactfine));
		me["c3.b4"].setTranslation(0,(1-tc3b2)*200*(rand5+pluscalcfactfine));
		me["c3.b5"].setTranslation(0,(1-tc3b3)*200*(rand4+pluscalcfactfine));
		me["c3.b6"].setTranslation(0,(1-tc3b3)*200*(rand5+pluscalcfactfine));


		var power_kw = getprop("systems/accel-electrical/fake-outputs/kw") or 0;
		var power_deg = power_kw/750 * 85;

		me["ddu10.kw"].setText(sprintf("%2d", math.round(power_kw)));
		me["bg.kw"].setRotation(power_deg*D2R);

		settimer(func me.update(), 0.02);
	}

};

setlistener("sim/signals/fdm-initialized", func {
	DDU10_display = canvas.new({
		"name": "DDU10",
		"size": [1024, 512],
		"view": [1024, 512],
		"mipmapping": 1
	});
	DDU10_display.addPlacement({"node": "display"});
	var groupMain = DDU10_display.createGroup();


	DDU10_main = canvas_DDU10_main.new(groupMain, instrument_dir~"DDU10_main.svg");

	DDU10_main.update();
	canvas_DDU10_base.update();
});

# if we go back from the weak gpu state
setlistener("aircraft/settings/weak_gpu", func(state) {
	var value = state.getValue();
	if(!value){
		DDU10_main.update();
		canvas_DDU10_base.update();
	}
});

var showDDU10 = func {
	var dlg = canvas.Window.new([330,165], "dialog").set("resize", 1);
	dlg.setCanvas(DDU10_display);
}
