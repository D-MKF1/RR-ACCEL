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
#		<info (at) marc-kraus.de> March, 2022									                    #
#################################################################################
var steady_sec = props.globals.getNode("/sim/time/steady-clock-sec",	1);

var comm1sel	= props.globals.getNode("instrumentation/comm[0]/frequencies/selected-mhz");
var comm1sby	= props.globals.getNode("instrumentation/comm[0]/frequencies/standby-mhz");

var comm1selmhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-mhz",0,"INT");
var comm1selkhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-khz",0,"INT");
var comm1sbymhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-mhz",0,"INT");
var comm1sbykhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-khz",0,"INT");

props.globals.initNode("instrumentation/comm[0]/mem-but-last-push-time",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/mon-but-last-push-time",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/standard-khz",1,"INT");
props.globals.initNode("instrumentation/comm[0]/airport-icao-text","ICAO","STRING");
props.globals.initNode("instrumentation/comm[0]/airport-type-text","TWR","STRING");
props.globals.initNode("instrumentation/comm[0]/but-pos",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/but-pos[6]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[0]/active-mon",0,"BOOL");
props.globals.initNode("instrumentation/comm[0]/active-settings",0,"INT");
props.globals.initNode("instrumentation/comm[0]/active-mem",0,"INT");
props.globals.initNode("instrumentation/comm[0]/active-mem-channel",0,"INT");
props.globals.initNode("instrumentation/comm[0]/active-gps-channel",0,"INT");
props.globals.initNode("instrumentation/comm[0]/active-gps-preselected-freq",0,"INT");
props.globals.initNode("instrumentation/comm[0]/frequencies/gps-mem/icao","","STRING");
props.globals.initNode("instrumentation/comm[0]/frequencies/gps-mem/frequency/ident","","STRING");
props.globals.initNode("instrumentation/comm[0]/frequencies/gps-mem/frequency/frequency",0.0,"DOUBLE");
for(var v=0; v <= 8; v+=1){
	props.globals.initNode("instrumentation/comm[0]/frequencies/active-mem-freq["~v~"]",0,"DOUBLE");
}

var comm2sel	= props.globals.getNode("instrumentation/comm[1]/frequencies/selected-mhz");
var comm2sby	= props.globals.getNode("instrumentation/comm[1]/frequencies/standby-mhz");

var comm2selmhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sel-mhz",0,"INT");
var comm2selkhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sel-khz",0,"INT");
var comm2sbymhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sby-mhz",0,"INT");
var comm2sbykhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sby-khz",0,"INT");

props.globals.initNode("instrumentation/comm[1]/mem-but-last-push-time",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/mon-but-last-push-time",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/standard-khz",1,"INT");
props.globals.initNode("instrumentation/comm[1]/airport-name-text","ICAO","STRING");
props.globals.initNode("instrumentation/comm[1]/airport-type-text","TWR","STRING");
props.globals.initNode("instrumentation/comm[1]/but-pos",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/but-pos[6]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/comm[1]/active-mon",0,"BOOL");
props.globals.initNode("instrumentation/comm[1]/active-settings",0,"INT");
props.globals.initNode("instrumentation/comm[1]/active-mem",0,"INT");
props.globals.initNode("instrumentation/comm[1]/active-mem-channel",0,"INT");
props.globals.initNode("instrumentation/comm[1]/active-gps-channel",0,"INT");
props.globals.initNode("instrumentation/comm[1]/active-gps-preselected-freq",0,"INT");
props.globals.initNode("instrumentation/comm[1]/frequencies/gps-mem/icao","","STRING");
props.globals.initNode("instrumentation/comm[1]/frequencies/gps-mem/frequency/ident","","STRING");
props.globals.initNode("instrumentation/comm[1]/frequencies/gps-mem/frequency/frequency",0.0,"DOUBLE");
for(var v=0; v <= 8; v+=1){
	props.globals.initNode("instrumentation/comm[1]/frequencies/active-mem-freq["~v~"]",0,"DOUBLE");
}

# Update support vars on comm change
setlistener(comm1sel, func {
  var commstr = sprintf("%.3f",comm1sel.getValue());	# String conversion
  var commtemp = split(".",commstr);			# Split into MHz and KHz
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
});
setlistener(comm1sby, func {
  var commstr = sprintf("%.3f",comm1sby.getValue());
  var commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);
});
setlistener(comm2sel, func {
  var commstr = sprintf("%.3f",comm2sel.getValue());
  var commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
});
setlistener(comm2sby, func {
  var commstr = sprintf("%.3f",comm2sby.getValue());
  var commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);
});

var sq_turn_step = func (v,dir){
	var vslave = v + 10;

	var turn_pos = getprop("instrumentation/comm["~v~"]/volume") or 0;
	var new_turn_pos = turn_pos + dir;
	var vslavevol = new_turn_pos - 0.2;

	var mon = getprop("instrumentation/comm["~v~"]/active-mon") or 0;

	if(vslavevol <= 0.1){
		setprop("instrumentation/comm["~vslave~"]/volume", 0);
		setprop("instrumentation/comm["~vslave~"]/power-btn", 0);
	}elsif(vslavevol > 1){
		setprop("instrumentation/comm["~vslave~"]/volume", vslavevol);
	}else{
		setprop("instrumentation/comm["~vslave~"]/volume", vslavevol);
		if(mon){
			setprop("instrumentation/comm["~vslave~"]/power-btn", 1);
		}
	}

	if(new_turn_pos < 0.1){
		setprop("instrumentation/comm["~v~"]/volume", 0);
		setprop("instrumentation/comm["~v~"]/power-btn", 0);
	}elsif(new_turn_pos > 1){
		setprop("instrumentation/comm["~v~"]/volume", 1);
	}else{
		setprop("instrumentation/comm["~v~"]/volume", new_turn_pos);
		setprop("instrumentation/comm["~v~"]/power-btn", 1);
	}
}

var turn_step = func (v,dir){
	var turn_pos = getprop("instrumentation/comm["~v~"]/but-pos[5]") or 0;
	var new_turn_pos = turn_pos + dir;
	setprop("instrumentation/comm["~v~"]/but-pos[5]", new_turn_pos);

	var mem_active = getprop("instrumentation/comm["~v~"]/active-mem") or 0;
	var set_active = getprop("instrumentation/comm["~v~"]/active-settings") or 0;

	if(set_active > 0){

		#do nothing, while setting mode is open
		
	}elsif(mem_active == 1){
		var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
		if(dir > 0){
			if(n >= 0 and n < 8){
				n = n + dir;
			}else{
				n = 0;
			}
		}else{
			if(n >= 1 and n < 9){
				n = n + dir;
			}else{
				n = 8;
			}
		}
		setprop("instrumentation/comm["~v~"]/active-mem-channel", n);
		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]"));

	}elsif(mem_active > 1){
		var n = getprop("instrumentation/comm["~v~"]/active-gps-channel") or 0;
		# how many frequencies has the airport?
		var allFreqs = props.globals.getNode("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]").getChildren("frequency");
		var max = size(allFreqs);
		var nf = getprop("instrumentation/comm["~v~"]/active-gps-preselected-freq") or 0;

		if(dir > 0){
			if(nf >= 0 and nf < max-1){
				nf = nf + dir;
			}else{
				nf = 0;
			}
		}else{
			if(nf >= 1 and nf < max){
				nf = nf + dir;
			}else{
				nf = max-1;
			}
		}

		setprop("instrumentation/comm["~v~"]/active-gps-preselected-freq", nf);
		setprop("instrumentation/comm["~v~"]/airport-icao-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/icao") or "--");
		setprop("instrumentation/comm["~v~"]/airport-type-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/frequency["~nf~"]/ident") or "--");
		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/frequency["~nf~"]/frequency") or 0.0);

	}else{
		var freq = getprop("instrumentation/comm["~v~"]/frequencies/standby-mhz") or 0;
		var khzsetting = getprop("instrumentation/comm["~v~"]/standard-khz");
		if(khzsetting == 2){
			freq = freq + 0.1*dir;
		}elsif(khzsetting == 1){
			freq = freq + 0.01*dir;
		}else{
			freq = freq + 0.001*dir;
		}

		# is the frequency allowed?
		if(freq > 137.0){
			freq = 117.975;
		}
		if(freq < 117.975){
			freq = 137.0;
		}

		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", freq);
	}
}

var big_turn_step = func (v,dir){
	var turn_pos = getprop("instrumentation/comm["~v~"]/but-pos[6]") or 0;
	var new_turn_pos = turn_pos + dir*10;
	setprop("instrumentation/comm["~v~"]/but-pos[6]", new_turn_pos);

	var mem_active = getprop("instrumentation/comm["~v~"]/active-mem") or 0;
	var set_active = getprop("instrumentation/comm["~v~"]/active-settings") or 0;

	if(set_active > 0){
		set_active = set_active + dir;
		if(set_active > 8){
			set_active = 1;
		}elsif(set_active < 1){
			set_active = 8;
		}else{
			#run
		}
		setprop("instrumentation/comm["~v~"]/active-settings", set_active);

	}elsif(mem_active > 0){
		# handle the remote gps frequencies
		var allgpsmems = props.globals.getNode("instrumentation/comm["~v~"]/frequencies/").getChildren("gps-mem");
		var allgps = size(allgpsmems);
		var findnr = 0;

		mem_active += dir;

		if(mem_active >= 2 and mem_active - 2 < allgps){
			findnr = mem_active - 2;
		}elsif(mem_active < 1){
			mem_active = 1 + allgps;
			findnr = allgps-1;
		}elsif(mem_active - 2 >= allgps){
			mem_active = 1;
		}else{
			mem_active = 1;
		}

		if(mem_active == 1){
			var mem_n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
			setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~mem_n~"]"));
			setprop("instrumentation/comm["~v~"]/active-gps-channel",0);
			setprop("instrumentation/comm["~v~"]/active-gps-preselected-freq",0);
		}else{
			setprop("instrumentation/comm["~v~"]/airport-icao-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~findnr~"]/icao") or "--");
			setprop("instrumentation/comm["~v~"]/airport-type-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~findnr~"]/frequency/ident") or "--");
			setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem["~findnr~"]/frequency/frequency") or 0.0);
			setprop("instrumentation/comm["~v~"]/active-gps-channel",findnr);
			setprop("instrumentation/comm["~v~"]/active-gps-preselected-freq",0);
		}

		setprop("instrumentation/comm["~v~"]/active-mem", mem_active);

	}else{
		var freq = getprop("instrumentation/comm["~v~"]/frequencies/standby-mhz") or 0;
		freq = freq + 1*dir;

		# is the frequency allowed?
		if(freq > 137.0){
			freq = 117.975;
		}
		if(freq < 117.975){
			freq = 137.0;
		}
		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", freq);
	}
}

var push_step = func (v){
    var n = getprop("instrumentation/comm["~v~"]/standard-khz") or 0;
    if(n < 2){
      n = n+1;
    }else{
      n = 0;
    }
    setprop("instrumentation/comm["~v~"]/standard-khz", n);
}

var push_mem = func (v,mode){
	var time = steady_sec.getDoubleValue();
	var mem_active = getprop("instrumentation/comm["~v~"]/active-mem") or 0;

	if(mode == "press"){
		setprop("instrumentation/comm["~v~"]/mem-but-last-push-time", time);

	}else{
		var lt = getprop("instrumentation/comm["~v~"]/mem-but-last-push-time");
		var diff = time - lt;
		if(diff < 1.5){
			if(mem_active == 0){
				#remote database frequencies and switch on the gps mode
				find_airport_in_range(v, 25);
				setprop("instrumentation/comm["~v~"]/active-mem",2);
				setprop("instrumentation/comm["~v~"]/airport-icao-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/icao") or "--");
				setprop("instrumentation/comm["~v~"]/airport-type-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/frequency/ident") or "--");
				setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/frequency/frequency") or 0.0);

			}else{
				setprop("instrumentation/comm["~v~"]/active-mem",0);
			}
		}else{
			if(mem_active == 0){
				# switch on the gps mode
				setprop("instrumentation/comm["~v~"]/active-mem",2);
				setprop("instrumentation/comm["~v~"]/airport-icao-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/icao") or "--");
				setprop("instrumentation/comm["~v~"]/airport-type-text", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/frequency/ident") or "--");
				setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/gps-mem/frequency/frequency") or 0.0);
				setprop("instrumentation/comm["~v~"]/active-gps-channel",0);
				setprop("instrumentation/comm["~v~"]/active-gps-preselected-freq",0);
			}
			if(mem_active == 1){
				var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
				# save primary frequency in memory
				setprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]", getprop("instrumentation/comm["~v~"]/frequencies/selected-mhz"));
				setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/selected-mhz"));
			}
		}
	}
}

var push_mon = func (v, mode){
	var time = steady_sec.getDoubleValue();
	var state = getprop("instrumentation/comm["~v~"]/active-mon") or 0;

	if(mode == "press"){
		setprop("instrumentation/comm["~v~"]/mon-but-last-push-time", time);

	}else{
		var lt = getprop("instrumentation/comm["~v~"]/mon-but-last-push-time");
		var diff = time - lt;
		if(diff < 1.5){
			var act_set = getprop("instrumentation/comm["~v~"]/active-settings") or 0;

			var vslave = v + 10;
			var vol = getprop("instrumentation/comm["~v~"]/volume") or 0;
			var vslavevol = vol - 0.1;

			if(act_set > 0){
				# if settings is active, short press of mon button stop it
				setprop("instrumentation/comm["~v~"]/active-settings",0);

			}elsif(state == 0){
				setprop("instrumentation/comm["~v~"]/active-mon", 1);
				# set the actuall stby frequency as selected frequency in the slave
				setprop("instrumentation/comm["~vslave~"]/frequencies/selected-mhz", getprop("instrumentation/comm["~v~"]/frequencies/standby-mhz") or 0);
				# switch on the slave
				# set volume from the slave comm[v+10] 0.1 less than the master comm[v]
				setprop("instrumentation/comm["~vslave~"]/volume", vslavevol);
				setprop("instrumentation/comm["~vslave~"]/power-btn", 1);


			}else{
				setprop("instrumentation/comm["~v~"]/active-mon", 0);
				# switch off the slave
				# set the actuall stby frequency as selected frequency in the slave
				setprop("instrumentation/comm["~vslave~"]/frequencies/selected-mhz", 0.0);
				# switch on the slave
				# set volume from the slave comm[v+10] 0.1 less than the master comm[v]
				setprop("instrumentation/comm["~vslave~"]/volume", 0);
				setprop("instrumentation/comm["~vslave~"]/power-btn", 0);
			}
		}else{
			setprop("instrumentation/comm["~v~"]/active-settings",1);
		}
	}
}

# start a listener on the standby-freq if monitoring is mem_active
var mon_standby = setlistener("instrumentation/comm[0]/frequencies/standby-mhz", func (frq) {
	var frq = frq.getValue() or 0.0;
	setprop("instrumentation/comm[10]/frequencies/selected-mhz",frq);
});

# start a listener on the standby-freq if monitoring is mem_active
var mon_standby1 = setlistener("instrumentation/comm[1]/frequencies/standby-mhz", func (frq) {
	var frq = frq.getValue() or 0.0;
	setprop("instrumentation/comm[11]/frequencies/selected-mhz",frq);
});


var find_airport_in_range = func(v, range){
	# clear up the last frequency tree
	props.globals.getNode("instrumentation/comm["~v~"]/frequencies").removeChildren("gps-mem");

	# find the Airports with this Nasal.function findAirportsWithinRange()
	var apts = findAirportsWithinRange(range);
	var n = 0;
	foreach(var apt; apts){
		var aptcomms = apt.comms();
		var nr = size(aptcomms);
		if(nr > 0){
			props.globals.initNode("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/icao",apt.id,"STRING");
			if(n == 0){
				setprop("instrumentation/comm["~v~"]/airport-icao-text", apt.id); # fill the first step in display
			}
			var i = 0;
			foreach(var aptcom; aptcomms){
				var shorttext = substr(aptcom.ident, 0, 7);
				if(n == 0 and i == 0){
					setprop("instrumentation/comm["~v~"]/airport-type-text", shorttext); # fill the first step in display
				}
				props.globals.initNode("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/frequency["~i~"]/ident",shorttext,"STRING");
				props.globals.initNode("instrumentation/comm["~v~"]/frequencies/gps-mem["~n~"]/frequency["~i~"]/frequency",aptcom.frequency,"DOUBLE");
				i += 1;
			}
			n += 1;
		}
	}
}

# Testfunction for the performance of another function
#var myFunc = func(){
#    for(var i = 0; i <= 10; i += 1){
#        print("Interation #", i);
#    }
#}
#var t = systime(); # record time
#push_mem(1); # run function
#var t2 = systime(); # record new time
#print("push_mem(1) took ", t2 - t, " seconds"); # print result

var ty92vhf_start = setlistener("/sim/signals/fdm-initialized", func {

	var comm1sel_init	= getprop("instrumentation/comm[0]/frequencies/selected-mhz") or 0;
	var comm1sby_init	= getprop("instrumentation/comm[0]/frequencies/standby-mhz") or 0;
	var comm2sel_init	= getprop("instrumentation/comm[1]/frequencies/selected-mhz") or 0;
	var comm2sby_init	= getprop("instrumentation/comm[1]/frequencies/standby-mhz") or 0;

	var c1sel = sprintf("%.3f",comm1sel_init);
	var ct1 = split(".",c1sel);
	comm1selmhz.setValue(ct1[0]);
  comm1selkhz.setValue(ct1[1]);

	var c1sby = sprintf("%.3f",comm1sby_init);
	var csby1 = split(".",c1sby);
  comm1sbymhz.setValue(csby1[0]);
  comm1sbykhz.setValue(csby1[1]);

	var c2sel = sprintf("%.3f",comm2sel_init);
	var ct2 = split(".",c2sel);
	comm2selmhz.setValue(ct2[0]);
	comm2selkhz.setValue(ct2[1]);

	var c2sby = sprintf("%.3f",comm2sby_init);
	var csby2 = split(".",c2sby);
  comm2sbymhz.setValue(csby2[0]);
  comm2sbykhz.setValue(csby2[1]);

	setprop("instrumentation/comm[10]/volume", 0);
	setprop("instrumentation/comm[10]/power-btn", 0);
	setprop("instrumentation/comm[11]/volume", 0);
	setprop("instrumentation/comm[11]/power-btn", 0);

	removelistener(ty92vhf_start);
});
