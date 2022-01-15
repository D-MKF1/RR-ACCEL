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
# If trim wheels are not on 0 and you click the center of this wheel
var trimBackTime = 1.0;
var applyTrimWheels = func(v, which = 0) {
    if (which == 0) { interpolate("/controls/flight/elevator-trim-pos", v, trimBackTime); }
    if (which == 1) { interpolate("/controls/flight/rudder-trim-pos", v, trimBackTime); }
    if (which == 2) { interpolate("/controls/flight/aileron-trim-pos", v, trimBackTime); }
}

var cover_emer1	   = props.globals.initNode("/controls/switches/emergency/cover[0]",0,"BOOL");
var cover_emer2	   = props.globals.initNode("/controls/switches/emergency/cover[1]",0,"BOOL");
var cover_emer3	   = props.globals.initNode("/controls/switches/emergency/cover[2]",0,"BOOL");

var emer1	   = props.globals.initNode("/controls/switches/emergency/switch[0]",0,"BOOL");
var emer2	   = props.globals.initNode("/controls/switches/emergency/switch[1]",0,"BOOL");
var emer3	   = props.globals.initNode("/controls/switches/emergency/switch[2]",0,"BOOL");

var trim_enable	   = props.globals.initNode("/controls/flight/trim-enable",0,"BOOL");
var rudder_trim_pos	   = props.globals.initNode("/controls/flight/rudder-trim-pos",0,"DOUBLE");
var aileron_trim_pos	 = props.globals.initNode("/controls/flight/aileron-trim-pos",0,"DOUBLE");
var elevator_trim_pos	 = props.globals.initNode("/controls/flight/elevator-trim-pos",0,"DOUBLE");


var ACCELSystem =
{
    new : func()
    {
      var m = { parents : [ACCELSystem]};
      m.reset();
      return m;
    },

    reset : func()
    {
      me.LastSimTime = 0.0;
    },

    update : func()
    {
        var CurrentTime = getprop("/sim/time/elapsed-sec");
        var dt = CurrentTime - me.LastSimTime;
        var V1 = getprop("velocities/groundspeed-kt");
        var OnGround = getprop("gear/gear[1]/wow");

        ##### controll the shake effect
				if(V1 > 20)
				{
					setprop("rraccel/shake-effect/effect",1);
          if(OnGround < 0.5){
            setprop("controls/doors/canopy/position-norm", 0);
          }
				}else{
					setprop("rraccel/shake-effect/effect",0);
				}

        #### is there a ground contact?
        var c = getprop("/fdm/jsbsim/systems/crash-detect/crash-on-ground");
        if(c == 1){
          setprop("/controls/engines/engine/throttle", 0);
          setprop("/fdm/jsbsim/systems/crash-detect/crash-save", 1);
        }

        ####  trim setting
        var te = trim_enable.getBoolValue();
        var rtp = rudder_trim_pos.getDoubleValue();
        var atp = aileron_trim_pos.getDoubleValue();
        var etp = elevator_trim_pos.getDoubleValue();

        if(te == 1){
          setprop("/controls/flight/rudder-trim", rtp);
          setprop("/controls/flight/aileron-trim", atp);
          setprop("/controls/flight/elevator-trim", etp);
        }else{
          setprop("/controls/flight/rudder-trim", 0.0);
          setprop("/controls/flight/aileron-trim", 0.0);
          setprop("/controls/flight/elevator-trim", 0.0);
        }

        ### Emergency switches on Trimpanel

        var ce1 = cover_emer1.getValue();
        var ce2 = cover_emer2.getValue();
        var ce3 = cover_emer3.getValue();

        if(ce1 == 0){
          emer1.setBoolValue(0);
        }
        if(ce2 == 0){
          emer2.setBoolValue(0);
        }
        if(ce3 == 0){
          emer3.setBoolValue(0);
        }

        ### The electrical-flight-events

        


        #<distance-8nm-287kts-start type="bool">0</distance-8nm-287kts-start>
        #<distance-8nm-287kts-start-alt type="double">0</distance-8nm-287kts-start-alt>
        #<distance-8nm-287kts-best-time type="double">0</distance-8nm-287kts-best-time>
        #<distance-8nm-287kts-last-time type="double">0</distance-8nm-287kts-last-time>
        #<distance-3min-300kts-start type="bool">0</distance-3min-300kts-start>
        #<distance-3min-300kts-start-alt type="double">0</distance-3min-300kts-start-alt>
        #<distance-3min-300kts-best-time type="double">0</distance-3min-300kts-best-time>
        #<distance-3min-300kts-last-time type="double">0</distance-3min-300kts-last-time>
        #<highspeed-start type="bool">0</highspeed-start>
        #<highspeed-start-alt type="double">0</highspeed-start-alt>
        #<highspeed-best-max type="double">0</highspeed-best-max>
        #<highspeed-last-max type="double">0</highspeed-last-max>
        #<climb-9840ft-start type="bool">0</climb-9840ft-start>
        #<climb-9840ft-start-alt type="double">0</climb-9840ft-start-alt>
        #<climb-9840ft-best-time type="double">0</climb-9840ft-best-time>
        #<climb-9840ft-last-time type="double">0</climb-9840ft-last-time>







        ### update the main loop
        me.LastSimTime = CurrentTime;
        settimer(func { ACCELSys.update(); },0.2);

    },
    changeView : func(n){
      var actualView = props.globals.getNode("sim/current-view/view-number", 1);
      if (actualView.getValue() == n){
        actualView.setValue(0);
      }else{
        actualView.setValue(n);
      }
    },
};


var ACCELSys = ACCELSystem.new();

setlistener("sim/signals/fdm-initialized",
            # executed on _every_ FDM reset (but not installing new listeners)
            func(idle) { ACCELSys.reset(); },
            0,0);

settimer(func()
         {
           ACCELSys.update();
         }, 5);




 ################## Little Help Window on bottom of screen #################
 var help_win = screen.window.new( 0, 0, 1, 5 );
 help_win.fg = [1,1,1,1];

 var messenger = func{
 help_win.write(arg[0]);
 }

 var h_altimeter = func {
 	var press_inhg = getprop("instrumentation/altimeter/setting-inhg");
 	var press_qnh = getprop("instrumentation/altimeter/setting-hpa");
 	if(  press_inhg == nil ) press_inhg = 0.0;
 	if(  press_qnh == nil ) press_qnh = 0.0;
 	help_win.write(sprintf("Baro alt pressure: %.0f hpa %.2f inhg ", press_qnh, press_inhg) );
 }

 var h_ruddertrim = func {
   var rdt = getprop("controls/flight/rudder-trim-pos");
   if(  rdt == nil ) rdt = 0.0;
   help_win.write(sprintf("Rudder trim pos: %.2f", rdt) );
 }

 var h_ailerontrim = func {
   var rdt = getprop("controls/flight/aileron-trim-pos");
   if(  rdt == nil ) rdt = 0.0;
   help_win.write(sprintf("Aileron trim pos: %.2f", rdt) );
 }

 var h_elevatortrim = func {
   var rdt = getprop("controls/flight/elevator-trim-pos");
   if(  rdt == nil ) rdt = 0.0;
   help_win.write(sprintf("Elevator trim pos: %.2f", rdt) );
 }

 var h_mtp = func {
   var rdt = getprop("controls/mtp/rpm");
   if(  rdt == nil ) rdt = 0.0;
   help_win.write(sprintf("MT Propeller RPM Setting: %.0f", rdt) );
 }

 var h_vs = func {
	var press_vs = getprop("autopilot/settings/vertical-speed-fpm");
	if(  press_vs == nil ) press_vs = 0.0;
	help_win.write(sprintf("Vertical speed: %.0f ", press_vs) );
}

var h_tas = func {
	var press_tas = getprop("autopilot/settings/target-speed-kt");
	if(  press_tas == nil ) press_tas = 0.0;
	help_win.write(sprintf("Target speed: %.0f ", press_tas) );
}

setlistener( "instrumentation/altimeter/setting-hpa", h_altimeter );
setlistener( "controls/flight/rudder-trim-pos", h_ruddertrim );
setlistener( "controls/flight/aileron-trim-pos", h_ailerontrim );
setlistener( "controls/flight/elevator-trim-pos", h_elevatortrim );
setlistener( "controls/mtp/rpm", h_mtp );
setlistener( "autopilot/settings/vertical-speed-fpm", h_vs );
setlistener( "autopilot/settings/target-speed-kt", h_tas );
