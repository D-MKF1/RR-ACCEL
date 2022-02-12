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
var comm1sel	= props.globals.getNode("instrumentation/comm[0]/frequencies/selected-mhz");
var comm1sby	= props.globals.getNode("instrumentation/comm[0]/frequencies/standby-mhz");
var comm1selstr	= props.globals.getNode("instrumentation/comm[0]/frequencies/selected-mhz-fmt");
var comm1sbystr	= props.globals.getNode("instrumentation/comm[0]/frequencies/standby-mhz-fmt");

var comm1standardkhz= props.globals.initNode("instrumentation/comm[0]/standard-khz",0,"INT");
var comm1selmhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-mhz",0,"INT");
var comm1selkhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sel-khz",0,"INT");
var comm1sbymhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-mhz",0,"INT");
var comm1sbykhz= props.globals.initNode("instrumentation/comm[0]/frequencies/display-sby-khz",0,"INT");
var but0pos = props.globals.initNode("instrumentation/comm[0]/but-pos",0.0,"DOUBLE");
var but1pos = props.globals.initNode("instrumentation/comm[0]/but-pos[1]",0.0,"DOUBLE");
var but2pos = props.globals.initNode("instrumentation/comm[0]/but-pos[2]",0.0,"DOUBLE");
var but3pos = props.globals.initNode("instrumentation/comm[0]/but-pos[3]",0.0,"DOUBLE");
var active_mon = props.globals.initNode("instrumentation/comm[0]/active-mon",0,"BOOL");
var active_mem = props.globals.initNode("instrumentation/comm[0]/active-mem",0,"BOOL");
var active_mem_channel = props.globals.initNode("instrumentation/comm[0]/active-mem-channel",0,"INT");
for(var v=0; v <= 8; v+=1){
	props.globals.initNode("instrumentation/comm[0]/frequencies/active-mem-freq["~v~"]",0,"DOUBLE");
}

var comm2standardkhz= props.globals.initNode("instrumentation/comm[1]/standard-khz",0,"INT");
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
var active_mon1 = props.globals.initNode("instrumentation/comm[1]/active-mon",0,"BOOL");
var active_mem1 = props.globals.initNode("instrumentation/comm[1]/active-mem",0,"BOOL");
var active_mem_channel1 = props.globals.initNode("instrumentation/comm[1]/active-mem-channel",0,"INT");
for(var v=0; v <= 8; v+=1){
	props.globals.initNode("instrumentation/comm[1]/frequencies/active-mem-freq["~v~"]",0,"DOUBLE");
}

# Update support vars on comm change
setlistener(comm1sel, func {
  var commstr = sprintf("%.2f",comm1sel.getValue());	# String conversion
  var commtemp = split(".",commstr);			# Split into MHz and KHz
  comm1selmhz.setValue(commtemp[0]);
  comm1selkhz.setValue(commtemp[1]);
});
setlistener(comm1sby, func {
  var commstr = sprintf("%.2f",comm1sby.getValue());
  var commtemp = split(".",commstr);
  comm1sbymhz.setValue(commtemp[0]);
  comm1sbykhz.setValue(commtemp[1]);
});
setlistener(comm2sel, func {
  var commstr = sprintf("%.2f",comm2sel.getValue());
  var commtemp = split(".",commstr);
  comm2selmhz.setValue(commtemp[0]);
  comm2selkhz.setValue(commtemp[1]);
});
setlistener(comm2sby, func {
  var commstr = sprintf("%.2f",comm2sby.getValue());
  var commtemp = split(".",commstr);
  comm2sbymhz.setValue(commtemp[0]);
  comm2sbykhz.setValue(commtemp[1]);
});

var push_step = func (v){
	if((v == 0 and active_mem.getValue()) or (v == 1 and active_mem1.getValue())){
    var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
    if(n < 8){
      n = n+1;
    }else{
      n = 0;
    }
    setprop("instrumentation/comm["~v~"]/active-mem-channel", n);
		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]"));
  }else{
    var n = getprop("instrumentation/comm["~v~"]/standard-khz") or 0;
    if(n < 2){
      n = n+1;
    }else{
      n = 0;
    }
    setprop("instrumentation/comm["~v~"]/standard-khz", n);
  }
}

var push_mem = func (v){
	if((v == 0 and active_mem.getValue()) or (v == 1 and active_mem1.getValue())){
    var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
		setprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]", getprop("instrumentation/comm["~v~"]/frequencies/standby-mhz"));
		if(v == 0){
				active_mem.setBoolValue(0);
		}
		if(v == 1){
				active_mem1.setBoolValue(0);
		}
	}else{
		var n = getprop("instrumentation/comm["~v~"]/active-mem-channel") or 0;
		setprop("instrumentation/comm["~v~"]/frequencies/standby-mhz", getprop("instrumentation/comm["~v~"]/frequencies/active-mem-freq["~n~"]"));
    if(v == 0){
				active_mem.setBoolValue(1);
		}
		if(v == 1){
				active_mem1.setBoolValue(1);
		}
  }
}
