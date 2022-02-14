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
#		<info (at) marc-kraus.de> Februar, 2022									                    #
#################################################################################
var steady_sec = props.globals.getNode("/sim/time/steady-clock-sec",	1);
var last_time = props.globals.initNode("instrumentation/comm[0]/mem-but-last-push-time",0.0,"DOUBLE");
var last_time1 = props.globals.initNode("instrumentation/comm[1]/mem-but-last-push-time",0.0,"DOUBLE");

var comm1sel	= props.globals.getNode("instrumentation/comm[0]/frequencies/selected-mhz");
var comm1sby	= props.globals.getNode("instrumentation/comm[0]/frequencies/standby-mhz");
var comm1selstr	= props.globals.getNode("instrumentation/comm[0]/frequencies/selected-mhz-fmt");
var comm1sbystr	= props.globals.getNode("instrumentation/comm[0]/frequencies/standby-mhz-fmt");

var comm1standardkhz= props.globals.initNode("instrumentation/comm[0]/standard-khz",1,"INT");
var comm1selmhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-mhz",0,"INT");
var comm1selkhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-khz",0,"INT");
var comm1sbymhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-mhz",0,"INT");
var comm1sbykhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-khz",0,"INT");
var but0pos = props.globals.initNode("instrumentation/comm[0]/but-pos",0.0,"DOUBLE");
var but1pos = props.globals.initNode("instrumentation/comm[0]/but-pos[1]",0.0,"DOUBLE");
var but2pos = props.globals.initNode("instrumentation/comm[0]/but-pos[2]",0.0,"DOUBLE");
var but3pos = props.globals.initNode("instrumentation/comm[0]/but-pos[3]",0.0,"DOUBLE");
var but4pos = props.globals.initNode("instrumentation/comm[0]/but-pos[4]",0.0,"DOUBLE");
var but5pos = props.globals.initNode("instrumentation/comm[0]/but-pos[5]",0.0,"DOUBLE");
var but5pos = props.globals.initNode("instrumentation/comm[0]/but-pos[6]",0.0,"DOUBLE");
var active_mon = props.globals.initNode("instrumentation/comm[0]/active-mon",0,"BOOL");
var active_mem = props.globals.initNode("instrumentation/comm[0]/active-mem",0,"INT");
var active_mem_channel = props.globals.initNode("instrumentation/comm[0]/active-mem-channel",0,"INT");
for(var v=0; v <= 8; v+=1){
	props.globals.initNode("instrumentation/comm[0]/frequencies/active-mem-freq["~v~"]",0,"DOUBLE");
}

var comm2standardkhz= props.globals.initNode("instrumentation/comm[1]/standard-khz",1,"INT");
var comm2sel	= props.globals.getNode("instrumentation/comm[1]/frequencies/selected-mhz");
var comm2sby	= props.globals.getNode("instrumentation/comm[1]/frequencies/standby-mhz");
var comm2selstr	= props.globals.getNode("instrumentation/comm[1]/frequencies/selected-mhz-fmt");
var comm2sbystr	= props.globals.getNode("instrumentation/comm[1]/frequencies/standby-mhz-fmt");

var comm2selmhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sel-mhz",0,"INT");
var comm2selkhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sel-khz",0,"INT");
var comm2sbymhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sby-mhz",0,"INT");
var comm2sbykhz= props.globals.initNode("instrumentation/comm[1]/frequencies/display-sby-khz",0,"INT");
var but0pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos",0.0,"DOUBLE");
var but1pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[1]",0.0,"DOUBLE");
var but2pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[2]",0.0,"DOUBLE");
var but3pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[3]",0.0,"DOUBLE");
var but4pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[4]",0.0,"DOUBLE");
var but5pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[5]",0.0,"DOUBLE");
var but5pos1 = props.globals.initNode("instrumentation/comm[1]/but-pos[6]",0.0,"DOUBLE");
var active_mon1 = props.globals.initNode("instrumentation/comm[1]/active-mon",0,"BOOL");
var active_mem1 = props.globals.initNode("instrumentation/comm[1]/active-mem",0,"INT");
var active_mem_channel1 = props.globals.initNode("instrumentation/comm[1]/active-mem-channel",0,"INT");
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

var turn_step = func (v,dir){
	var turn_pos = getprop("instrumentation/comm["~v~"]/but-pos[5]") or 0;
	var new_turn_pos = turn_pos + dir;
	setprop("instrumentation/comm["~v~"]/but-pos[5]", new_turn_pos);

	var mem_active = getprop("instrumentation/comm["~v~"]/active-mem") or 0;

	if(mem_active == 1){
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

	if(mem_active > 0){
		# here we will later handle all the airports and frequencies
		# if the mem button was pressed, this knob function can scroll through the airport list.
		# the small knob can scroll all the frequencies from the selected airport.

		if(mem_active == 1){
			mem_active = 2;
		}else{
			mem_active = 1;
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
				setprop("instrumentation/comm["~v~"]/active-mem",2);
			}else{
				setprop("instrumentation/comm["~v~"]/active-mem",0);
			}
		}else{
			if(mem_active == 0){
				setprop("instrumentation/comm["~v~"]/active-mem",2);
			}

			if(mem_active == 1){
				var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
				# save primary frequency in memory
				setprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]", getprop("instrumentation/comm["~v~"]/frequencies/selected-mhz"));
			}
		}
	}
}

  # find the frequencies of one Airport - but only in the menu, not in a property tree
	#		<binding>
	#			<command>ATC-freq-display</command>
	#			<icao type="string">EDNY</icao>
	#		</binding>


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

});
