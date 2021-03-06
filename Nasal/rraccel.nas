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
#		<info (at) marc-kraus.de> March, 2022									                        #
#################################################################################
# settings
props.globals.initNode("/aircraft/settings/inside-canopy",1,"BOOL");
props.globals.initNode("/aircraft/settings/internal-pilot",1,"BOOL");

# If trim wheels are not on 0 and you click the center of this wheel
var trimBackTime = 1.0;
var applyTrimWheels = func(v, which = 0) {
    if (which == 0) { interpolate("/controls/flight/elevator-trim", v, trimBackTime); }
    if (which == 1) { interpolate("/controls/flight/rudder-trim", v, trimBackTime); }
    if (which == 2) { interpolate("/controls/flight/aileron-trim", v, trimBackTime); }
}

var weakgpu	   = props.globals.initNode("/aircraft/settings/weak_gpu",0,"BOOL");

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
          setprop("/systems/accel-electrical/battery/battery-charge-percent", 0);
          setprop("/systems/accel-electrical/battery/engine-limit", 0);
          setprop("/systems/accel-electrical/battery/engine-volts", 0);
          setprop("/fdm/jsbsim/systems/crash-detect/crash-save", 1);
          setprop("/controls/mtp/rpm",0);
          setprop("/controls/mtp/manu",1);
          setprop("/controls/gear/gear-down",0);
        }

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

var rraccel_init = setlistener("/sim/signals/fdm-initialized", func(idle) {
  ACCELSys.reset();
  removelistener( rraccel_init ); }, 0,0);

settimer(func()
         {
           ACCELSys.update();
         }, 5);



################## Little Help Window on bottom of screen #################
# called from the instruments knobs, switches or levers
#<binding>
#  <command>nasal</command>
#  <script>rraccel.h_altimeter()</script>
#</binding>

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
 var rdt = getprop("controls/flight/rudder-trim");
 if(  rdt == nil ) rdt = 0.0;
 help_win.write(sprintf("Rudder trim pos: %.2f", rdt) );
}

var h_ailerontrim = func {
 var rdt = getprop("controls/flight/aileron-trim");
 if(  rdt == nil ) rdt = 0.0;
 help_win.write(sprintf("Aileron trim pos: %.2f", rdt) );
}

var h_elevatortrim = func {
 var rdt = getprop("controls/flight/elevator-trim");
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
