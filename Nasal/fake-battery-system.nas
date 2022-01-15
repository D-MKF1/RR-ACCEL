#################################################################################
#		Lake of Constance Hangar												                            #
#	  RR-ACCEL for Flightgear												                              #
#		Copyright (C) 2022 M.Kraus												                          #
#																				                                        #
#		This program is free software: you can redistribute it and/or modify	      #
#		it under the terms of the GNU General Public License as published by	      #
#		the Free Software Foundation, either version 3 of the License, or		        #
#		(at your option) any later version.										                      #
#																				                                        #
#		This program is distributed in the hope that it will be useful,			        #
#		but WITHOUT ANY WARRANTY; without even the implied warranty of			        #
#		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the			          #
#		GNU General Public License for more details.							                  #
#																				                                        #
#		You should have received a copy of the GNU General Public License		        #
#		along with this program.  If not, see <http://www.gnu.org/licenses/>.	      #
#																				                                        #
#		Every software has a developer, also free software. 					              #
#		As a gesture of courtesy and respect, I would be delighted 				          #
#		if you contacted me before making any changes to this software. 		        #
#		<info (at) marc-kraus.de> Dec, 2021									                        #
#################################################################################

# Das Aufladen erfolgt einfach über das Anlegen einer höheren Spannung auf den bus, als sie in engine-volts anliegt.

var fbs_electrical_loop = nil;
var last_time = nil;

# Properties

var property_base	= props.globals.getNode("/systems/accel-electrical/", 1);
var electrical_base	= property_base.initNode("battery");

var start		= property_base.initNode("start", 0, "BOOL");				#	0 : switched off; 0-1 : starting up; 1: running
var start12v		= property_base.initNode("start12v", 0, "BOOL");		#	0 : switched off; 0-1 : starting up; 1: running
var startsystems		= property_base.initNode("startsys", 0,"DOUBLE"); 	#create the system start procedere
var bus_volts		= property_base.initNode("outputs/bus", 0,"DOUBLE"); 	#Current supplied by the aircraft's avionics bus
var cabin_dim		= property_base.initNode("outputs/cabin-dim", 0,"DOUBLE"); # internal lights
var cabin_dim_pos	= property_base.initNode("outputs/cabin-dim-pos", 0,"DOUBLE"); # internal lights

var inst_output_prop_rot = property_base.initNode("fake-outputs/proppeller-rotation", 0,"DOUBLE"); 	# unfortunately I can't do it better due to lack of skills
var inst_output_eng_rpm = property_base.initNode("fake-outputs/engine-rpm", 0,"DOUBLE"); 	# unfortunately I can't do it better due to lack of skills
var inst_output_hp = property_base.initNode("fake-outputs/hp", 0,"DOUBLE"); 	# unfortunately I can't do it better due to lack of skills
var inst_output_kw = property_base.initNode("fake-outputs/kw", 0,"DOUBLE"); 	# unfortunately I can't do it better due to lack of skills


var cb0		= property_base.initNode("circuit-breakers/cb[0]", 1,"BOOL"); # switchpanel
var cb1		= property_base.initNode("circuit-breakers/cb[1]", 1,"BOOL"); # switchpanel
var cb2		= property_base.initNode("circuit-breakers/cb[2]", 1,"BOOL"); # switchpanel
var cb3		= property_base.initNode("circuit-breakers/cb[3]", 1,"BOOL"); # switchpanel
var cb4		= property_base.initNode("circuit-breakers/cb[4]", 1,"BOOL"); # switchpanel
var cb5		= property_base.initNode("circuit-breakers/cb[5]", 1,"BOOL"); # switchpanel
var cb6		= property_base.initNode("circuit-breakers/cb[6]", 1,"BOOL"); # switchpanel
var cb7		= property_base.initNode("circuit-breakers/cb[7]", 1,"BOOL"); # switchpanel
var cb8		= property_base.initNode("circuit-breakers/cb[8]", 1,"BOOL"); # switchpanel
var cb9		= property_base.initNode("circuit-breakers/cb[9]", 1,"BOOL"); # switchpanel
var cb10	= property_base.initNode("circuit-breakers/cb[10]", 1,"BOOL"); # switchpanel
var b0		= property_base.initNode("buttons/b[0]", 0,"BOOL"); # switchpanel
var b1		= property_base.initNode("buttons/b[1]", 0,"BOOL"); # switchpanel
var b2		= property_base.initNode("buttons/b[2]", 0,"BOOL"); # switchpanel
var b3		= property_base.initNode("buttons/b[3]", 0,"BOOL"); # switchpanel
var b4		= property_base.initNode("buttons/b[4]", 0,"BOOL"); # switchpanel
var b5		= property_base.initNode("buttons/b[5]", 0,"BOOL"); # switchpanel
var b6		= property_base.initNode("buttons/b[6]", 0,"BOOL"); # switchpanel
var b7		= property_base.initNode("buttons/b[7]", 0,"BOOL"); # switchpanel
var b8		= property_base.initNode("buttons/b[8]", 0,"BOOL"); # switchpanel
var b9		= property_base.initNode("buttons/b[9]", 0,"BOOL"); # switchpanel

var ins_volts		= electrical_base.initNode("engine-volts", 0.0, "DOUBLE");		#	voltage fed to the engine
var charge		= electrical_base.initNode("battery-charge-percent", 1.0, "DOUBLE");	#	internal battery charge
var load		= electrical_base.initNode("load", 0.0, "DOUBLE");			#	internal battery load
var calculated_rest_hours		= electrical_base.initNode("crh", 1.0, "DOUBLE");			#	how long stay the battery
var bus_load		= electrical_base.initNode("bus-load", 0.0, "DOUBLE");			#	Load on the avionics bus (from this engine)
var ffb			= electrical_base.initNode("feed-from-battery", 0, "BOOL");		#	0: fed from avionics bus 1: fed from internal battery
var eng_limit		= electrical_base.initNode("engine-limit", 0.0, "DOUBLE");		#	main param give his values in jsbsim to fcs/throttle-pos-norm and fcs/throttle-cmd-norm
var bc			= electrical_base.initNode("battery-charging", 0, "BOOL");		#	0: not charging 1: charging


# only for the two lean instruments from the Instruments-3d folder
setprop("/systems/electrical/outputs/comm[0]",0);
setprop("/systems/electrical/outputs/transponder",0);


var throttle = props.globals.getNode("/controls/engines/engine[0]/throttle", 1);
var engine_rpm = props.globals.getNode("/engines/engine/rpm", 1);
var power_hp = props.globals.getNode("/fdm/jsbsim/propulsion/engine/power-hp", 1);
var prop_rpm = props.globals.getNode("/fdm/jsbsim/propulsion/engine/propeller-rpm",1);
var mtp_low = props.globals.getNode("/controls/mtp/low", 1);
var mtp_manu = props.globals.getNode("/controls/mtp/manu", 1);
var blade_angle_pos = props.globals.initNode("/fdm/jsbsim/propulsion/engine/blade-angle-pos",0.0,"DOUBLE");


var elapsed_sec = props.globals.getNode("/sim/time/elapsed-sec",	1);
var replay_state	= props.globals.getNode("/sim/freeze/replay-state",	1);
var last_time	= props.globals.getNode("/sim/time/steady-clock-sec",	1);

var BatteryClass = {
		new : func {
			var obj = {
				parents : [BatteryClass],
				ideal_volts : 750.0,
				ideal_amps : 1000.0,
				amp_hours : 288.0,
				charge_percent : 1.0,
				charge_amps : 0.88,			# acid battery 0.56 / Lithium ion battery 0.8 - 0.9
				};
			charge.setValue(obj.charge_percent);
			return obj;
		},
		apply_load : func (amps, dt) {
			load.setValue(amps);
			var old_charge_percent = charge.getValue();

			if(amps > 0.0){
				calculated_rest_hours.setValue(me.amp_hours*old_charge_percent/amps);
			}

			if ( replay_state.getBoolValue() )
				return me.amp_hours * old_charge_percent;

			var amphrs_used = amps * dt / 3600.0;
			var percent_used = amphrs_used / me.amp_hours;

			var new_charge_percent = std.max(0.0, std.min(old_charge_percent - percent_used, 1.0));

			me.charge_percent = new_charge_percent;
			charge.setValue(new_charge_percent);
			return me.amp_hours * new_charge_percent;
		},
		get_output_volts : func {
			var x = 1.0 - me.charge_percent;
			var tmp = -(3.0 * x - 1.0);
			var factor = (math.pow(tmp, 5) + 32) / 32;
			return me.ideal_volts * factor;
		},
		get_output_amps : func {
			var x = 1.0 - me.charge_percent;
			var tmp = -(3.0 * x - 1.0);
			var factor = (math.pow(tmp, 5) + 32) / 32;
			return me.ideal_amps * factor;
		},
		reset_to_full_charge : func {
			me.apply_load(-(1.0 - me.charge_percent) * me.amp_hours, 3600);
		},
	};



var internal_battery = BatteryClass.new();


var update_electrical = func () {
	var time = elapsed_sec.getDoubleValue();
	var dt = time - last_time;
	last_time = time;

	#print( "last_time = ", last_time );
	#print("dt = ", dt);

	var start_v = start.getBoolValue();
	var start12v_v = start12v.getBoolValue();
	var bus_volts_v = bus_volts.getValue();
	var startsys_state = startsystems.getValue();
	var battery_volts = internal_battery.get_output_volts();
	var charge_v = charge.getValue();
	var throttle_v = throttle.getValue();

	var engine_consumption = 0.0;

	####### this lines to feed the Instruments-3d and set the blade-angle from mtp
	if( start12v_v){
		if(startsys_state <= 0){interpolate("/systems/accel-electrical/startsys",1,6);}
		setprop("/systems/electrical/outputs/comm[0]",28);
		setprop("/systems/electrical/outputs/transponder",28);
		cabin_dim.setDoubleValue(cabin_dim_pos.getValue());

	}else{
		setprop("/systems/electrical/outputs/comm[0]",0);
		setprop("/systems/electrical/outputs/transponder",0);
		cabin_dim.setDoubleValue(0.0);
		startsystems.setDoubleValue(0.0);
	}

  #### listen to propeller pitch setting in the mt-propeller instrument - do not change anything in the thrust, only in view
  var mtrpm = getprop("/controls/mtp/rpm");   #range from 1400 to 2400 / Propeller pitch from 2 to 85 degree
  var mtba = 85-((mtrpm - 1400) * 0.083);
  blade_angle_pos.setDoubleValue(mtba);

	var iopr = 0;
	var ioer = 0;
	var iohp = 0;
	var iokw = 0;

	if( start_v == 1){

		var min_volts = internal_battery.ideal_volts - 50;

		if(ins_volts.getValue() < min_volts){
			# correction for the los of performance
			var is_eng_limit = eng_limit.getDoubleValue();

			var corr_eng_limit = is_eng_limit*ins_volts.getValue()/min_volts;
			eng_limit.setDoubleValue(corr_eng_limit);
		}

		# average is 450kW, max 750kW | 0.7456 hp to kw | *1000 to get Watt not the kw after ht to kw
		engine_consumption = power_hp.getValue() * 0.7457 * 1000;

		# fake consumption correction
		if(engine_consumption > 3000000){
				engine_consumption = 1500000;
				if(prop_rpm.getValue()>2400){iopr = 2400};
				if(engine_rpm.getValue()>2450){ioer = 2425};
				if(power_hp.getValue()>1100){iohp = 1005};
				iokw = iohp * 0.7457;

		}elsif(engine_consumption > 760000){
			engine_consumption = 900000;
			if(prop_rpm.getValue()>2300){iopr = 2304};
			if(engine_rpm.getValue()>2320){ioer = 2310};
			if(power_hp.getValue()>1100){iohp = 950};
			iokw = iohp * 0.7457;

		}else{
			engine_consumption = engine_consumption;
			iopr = prop_rpm.getValue()*0.9;
			ioer = engine_rpm.getValue()*0.9;
			iohp = power_hp.getValue()*0.8;
			iokw = iohp * 0.7457;
		}
		inst_output_prop_rot.setDoubleValue(iopr);
		inst_output_eng_rpm.setDoubleValue(ioer);
		inst_output_hp.setDoubleValue(iohp);
		inst_output_kw.setDoubleValue(iokw);
	}

	if( bus_volts_v > battery_volts ){						# The engine electrical system is fed from the avionics bus
		if ( charge_v < 1.0 ){
			internal_battery.apply_load(-internal_battery.charge_amps, dt);
			bc.setValue(1);
			bus_load.setValue(internal_battery.charge_amps*bus_volts_v + engine_consumption);
		}else{
			bus_load.setValue(engine_consumption);
			bc.setValue(0);
		}
		ins_volts.setValue(bus_volts_v);
		ffb.setValue(0);
	} else {									# The engine electrical system is fed from its internal battery
		ins_volts.setValue(battery_volts);
		ffb.setValue(1);
		bc.setValue(0);
		if ( battery_volts > 0 ){
			internal_battery.apply_load(engine_consumption/battery_volts, dt);
		}
	}
}


var elec_ls = setlistener("/sim/signals/fdm-initialized", func {
	internal_battery.reset_to_full_charge();
	last_time = elapsed_sec.getDoubleValue();
	fbs_electrical_loop = maketimer(0.2, update_electrical);
	fbs_electrical_loop.simulatedTime = 1;
	fbs_electrical_loop.start();
	removelistener( elec_ls );
});


setlistener("/controls/mtp/low", func(state){
	var state = state.getValue() or 0;
	if(state){
		setprop("/systems/accel-electrical/battery/engine-limit",1.5);
		setprop("/systems/accel-electrical/buttons/b[5]",0);
	}else{
		interpolate("/systems/accel-electrical/battery/engine-limit",2.8,4);
	}
},0,0);

setlistener("/systems/accel-electrical/buttons/b[5]", func(state){
	var state = state.getValue() or 0;
	if(state){
		interpolate("/systems/accel-electrical/battery/engine-limit",5,3);
	}else{
		var mtp = getprop("/controls/mtp/low");
		if(mtp == 1){
			setprop("/systems/accel-electrical/battery/engine-limit",1.5);
		}else{
			setprop("/systems/accel-electrical/battery/engine-limit",4);
		}
	}
},0,0);

setlistener("/systems/accel-electrical/start", func(state){
	var state = state.getValue() or 0;
	if(state){
		setprop("/systems/accel-electrical/battery/engine-limit",1.5);
	}else{
		setprop("/systems/accel-electrical/battery/engine-limit",0);
	}
},0,0);
