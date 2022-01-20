#=======================================================================
# In copilot mode the value of autopilot kill all pilot - copilot action
# ok, so pilot settings must be written to switch boolean values
#=======================================================================
setlistener("/sim/signals/fdm-initialized", func {
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/locks/speed", "");
      setprop("/autopilot/switches/ap", 0);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/ias", 0);
      setprop("/autopilot/switches/gps", 0);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/vs", 0);
});

setlistener("/autopilot/switches/ap", func (ap){
    var ap = ap.getBoolValue();
    if (ap == 1){
      var hdgSet = getprop("/autopilot/switches/hdg");
      var altSet = getprop("/autopilot/switches/alt");
      var iasSet = getprop("/autopilot/switches/ias");
      var navSet = getprop("/autopilot/switches/nav");
      var apprSet = getprop("/autopilot/switches/appr");
      var vsSet = getprop("/autopilot/switches/vs");
      var hdgGps = getprop("/autopilot/switches/gps");

      if((!hdgSet and !altSet and !iasSet and !navSet and !apprSet and !vsSet and !hdgGps)){
        setprop("/autopilot/settings/heading-bug-deg",getprop("/orientation/heading-deg"));
        setprop("/autopilot/locks/heading", "dg-heading-hold");
        setprop("/autopilot/locks/altitude", "vertical-speed-hold");

      }
    }else{
      setprop("/autopilot/locks/altitude", "");
      setprop("/autopilot/locks/heading", "");
      setprop("/autopilot/locks/speed", "");
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/switches/ias", 0);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/vs", 0);
    }
});

setlistener("/autopilot/switches/hdg", func (hdg){
    var hdg = hdg.getValue();
    if (hdg == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/locks/heading", "dg-heading-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/gps", func (gps){
    var gps = gps.getValue();
    if (gps == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/nav", 0);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/locks/heading", "true-heading-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/alt", func (alt){
    var alt = alt.getValue();
    if (alt == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/appr", 0);
      setprop("/autopilot/switches/vs", 0);
      setprop("/autopilot/locks/altitude", "altitude-hold");
      setprop("/autopilot/settings/target-altitude-ft", getprop("/position/altitude-ft"));
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});

setlistener("/autopilot/switches/ias", func (ias){
    var ias = ias.getValue();
    if (ias == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/locks/speed", "speed-with-throttle");
    }else{
      setprop("/autopilot/locks/speed", "");
    }
});

setlistener("/autopilot/switches/nav", func (nav){
    var nav = nav.getValue();
    if (nav == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/hdg", 0);
      setprop("/autopilot/locks/heading", "nav1-hold");
    }else{
      setprop("/autopilot/locks/heading", "");
    }
});

setlistener("/autopilot/switches/appr", func (appr){
    var appr = appr.getValue();
    if (appr == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/locks/altitude", "gs1-hold");
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});


setlistener("/autopilot/switches/vs", func (vs){
    var vs = vs.getValue();
    if (vs == 1){
      setprop("/autopilot/switches/ap", 1);
      setprop("/autopilot/switches/alt", 0);
      setprop("/autopilot/locks/altitude", "vertical-speed-hold");
    }else{
      setprop("/autopilot/locks/altitude", "");
    }
});
