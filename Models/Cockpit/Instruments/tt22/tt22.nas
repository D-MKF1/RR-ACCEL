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

props.globals.initNode("instrumentation/transponder/show-manual",0.0,"BOOL");

props.globals.initNode("instrumentation/transponder/fn-active",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/flight-id",0.0,"STRING");
props.globals.initNode("instrumentation/transponder/inputs/enterstep",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[6]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/activeline[7]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[6]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[7]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposfix",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposfix[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposfix[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposfix[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposfix[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[6]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/fnposstep[7]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos[4]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/but-pos[5]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-vfr-swap",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-vfr-swap[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-vfr-swap[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-vfr-swap[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-set",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-set[1]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-set[2]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/transponder/inputs/digit-set[3]",0.0,"DOUBLE");
props.globals.initNode("instrumentation/altimeter/mode-s-alt-ft",0.0,"DOUBLE");

var ident_on = props.globals.getNode("instrumentation/transponder/ident",	1);
aircraft.light.new("instrumentation/transponder/request", [0.3, 1.0], ident_on);

var digits_translater = func (i, dir){
	var rt = "";
	if(dir > 0){
			# digits to lettersAndNumbers
			if(i == 0){
				rt = "";
			}elsif(i == 1){
				rt = "0";
			}elsif(i == 2){
				rt = "1";
			}elsif(i == 3){
				rt = "2";
			}elsif(i == 4){
				rt = "3";
			}elsif(i == 5){
				rt = "4";
			}elsif(i == 6){
				rt = "5";
			}elsif(i == 7){
				rt = "6";
			}elsif(i == 8){
				rt = "7";
			}elsif(i == 9){
				rt = "8";
			}elsif(i == 10){
				rt = "9";
			}elsif(i == 11){
				rt = "A";
			}elsif(i == 12){
				rt = "B";
			}elsif(i == 13){
				rt = "C";
			}elsif(i == 14){
				rt = "D";
			}elsif(i == 15){
				rt = "E";
			}elsif(i == 16){
				rt = "F";
			}elsif(i == 17){
				rt = "G";
			}elsif(i == 18){
				rt = "H";
			}elsif(i == 19){
				rt = "I";
			}elsif(i == 20){
				rt = "J";
			}elsif(i == 21){
				rt = "K";
			}elsif(i == 22){
				rt = "L";
			}elsif(i == 23){
				rt = "M";
			}elsif(i == 24){
				rt = "N";
			}elsif(i == 25){
				rt = "O";
			}elsif(i == 26){
				rt = "P";
			}elsif(i == 27){
				rt = "Q";
			}elsif(i == 28){
				rt = "R";
			}elsif(i == 29){
				rt = "S";
			}elsif(i == 30){
				rt = "T";
			}elsif(i == 31){
				rt = "U";
			}elsif(i == 32){
				rt = "V";
			}elsif(i == 33){
				rt = "W";
			}elsif(i == 34){
				rt = "X";
			}elsif(i == 35){
				rt = "Y";
			}elsif(i == 36){
				rt = "Z";
			}else{
				rt = "";
			}
	}else{
		# lettersAndNumbers to digits
		if(i == ""){
			rt = 0;
		}elsif(i == "0"){
			rt = 1;
		}elsif(i == "1"){
			rt = 2;
		}elsif(i == "2"){
			rt = 3;
		}elsif(i == "3"){
			rt = 4;
		}elsif(i == "4"){
			rt = 5;
		}elsif(i == "5"){
			rt = 6;
		}elsif(i == "6"){
			rt = 7;
		}elsif(i == "7"){
			rt = 8;
		}elsif(i == "8"){
			rt = 9;
		}elsif(i == "9"){
			rt = 10;
		}elsif(i == "A"){
			rt = 11;
		}elsif(i == "B"){
			rt = 12;
		}elsif(i == "C"){
			rt = 13;
		}elsif(i == "D"){
			rt = 14;
		}elsif(i == "E"){
			rt = 15;
		}elsif(i == "F"){
			rt = 16;
		}elsif(i == "G"){
			rt = 17;
		}elsif(i == "H"){
			rt = 18;
		}elsif(i == "I"){
			rt = 19;
		}elsif(i == "J"){
			rt = 20;
		}elsif(i == "K"){
			rt = 21;
		}elsif(i == "L"){
			rt = 22;
		}elsif(i == "M"){
			rt = 23;
		}elsif(i == "N"){
			rt = 24;
		}elsif(i == "O"){
			rt = 25;
		}elsif(i == "P"){
			rt = 26;
		}elsif(i == "Q"){
			rt = 27;
		}elsif(i == "R"){
			rt = 28;
		}elsif(i == "S"){
			rt = 29;
		}elsif(i == "T"){
			rt = 30;
		}elsif(i == "U"){
			rt = 31;
		}elsif(i == "V"){
			rt = 32;
		}elsif(i == "W"){
			rt = 33;
		}elsif(i == "X"){
			rt = 34;
		}elsif(i == "Y"){
			rt = 35;
		}elsif(i == "Z"){
			rt = 36;
		}else{
			rt = "";
		}
	}

	return rt;

}

var push_fn = func (){

	var fn_active = getprop("instrumentation/transponder/fn-active") or 0;

	fn_active = fn_active + 1;
	if(fn_active == 1){
		# write the squawk to the squawk-set
		for(var v=0; v <= 3; v+=1){
			setprop("instrumentation/transponder/inputs/digit-set["~v~"]", getprop("instrumentation/transponder/inputs/digit["~v~"]"));
		}

	}elsif(fn_active == 2){
		# write the fnposfix to fnposstep for edit
		for(var v=0; v <= 6; v+=1){
			setprop("instrumentation/transponder/inputs/fnposstep["~v~"]",0.0);
		}
		var fid = getprop("instrumentation/transponder/flight-id");
		#debug.dump(fid);
		fid = string.replace(fid,"-","");
		fid = string.replace(fid,"_","");
		fid = string.uc(fid);
		#fid = left(fid,8);
		var max = size(fid);

		for(var i=0; i < max; i+=1){
			var lettre = substr(fid, i, 1);
			var l = digits_translater(lettre,-1);
			setprop("instrumentation/transponder/inputs/fnposstep["~i~"]",l);
		}

	}elsif(fn_active > 4){
		fn_active = 0;
		setprop("instrumentation/transponder/inputs/enterstep",0);
	}else{
	  # do nothing
	}

	setprop("instrumentation/transponder/fn-active", fn_active);

}

var push_enter = func (){

	var fn_active = getprop("instrumentation/transponder/fn-active") or 0;
	var enter_steps = getprop("instrumentation/transponder/inputs/enterstep") or 0;

	if(fn_active == 1){
		var nr = 3 - enter_steps;
		enter_steps = enter_steps+1;
		if(enter_steps > 3){
			enter_steps = 0;
			setprop("instrumentation/transponder/fn-active", 0);
			setprop("instrumentation/transponder/inputs/digit[0]", getprop("instrumentation/transponder/inputs/digit-set[0]"));
			setprop("instrumentation/transponder/inputs/digit[1]", getprop("instrumentation/transponder/inputs/digit-set[1]"));
			setprop("instrumentation/transponder/inputs/digit[2]", getprop("instrumentation/transponder/inputs/digit-set[2]"));
			setprop("instrumentation/transponder/inputs/digit[3]", getprop("instrumentation/transponder/inputs/digit-set[3]"));
		}

	}elsif(fn_active == 2){
		enter_steps = enter_steps+1;
		if(enter_steps > 7){
			enter_steps = 0;
			#build the string to the flight-id string...
			var newString = "";
			for(var i=0; i < 6; i+=1){
				var lnr = getprop("instrumentation/transponder/inputs/fnposstep["~i~"]");
				if(lnr > 0){
					newString = newString  ~ digits_translater(lnr,1);
				}
			}

			for(var v=0; v <= 6; v+=1){
				setprop("instrumentation/transponder/inputs/fnposfix["~v~"]",0.0);
			}

			var max = size(newString);
			for(var i=0; i < max; i+=1){
				var lettre = substr(newString, i, 1);
				var fixpos = i + (8-max);
				var l = digits_translater(lettre,-1);
				setprop("instrumentation/transponder/inputs/fnposfix["~fixpos~"]",l);
			}

			setprop("instrumentation/transponder/flight-id", newString);
			setprop("instrumentation/transponder/fn-active", 0);
		}

	}else{
		enter_steps = 0;
	}

	setprop("instrumentation/transponder/inputs/enterstep", enter_steps);

}

var code_turn_step = func (dir){
	var turn_pos = getprop("instrumentation/transponder/but-pos[2]") or 0;
	var new_turn_pos = turn_pos + dir*10;
	setprop("instrumentation/transponder/but-pos[2]", new_turn_pos);

	var fn_active = getprop("instrumentation/transponder/fn-active") or 0;
	var v = getprop("instrumentation/transponder/inputs/enterstep") or 0;

	if(fn_active == 1){
		# set the ident squawk
		v = 3-v;
		var nr = getprop("instrumentation/transponder/inputs/digit-set["~v~"]") or 0;
		nr = nr + dir;

		if(nr > 7){
			nr = 0;
		}elsif(nr < 0){
			nr = 7;
		}else{
			#run
		}
		setprop("instrumentation/transponder/inputs/digit-set["~v~"]", nr);
	}elsif(fn_active == 2){
		# on the lettersAndNumbers.png find fnposstep the right letter or number
		var fn = getprop("instrumentation/transponder/inputs/fnposstep["~v~"]") or 0;
		fn = fn + dir;

		if(fn > 36){
			fn = 0;
		}elsif(fn < 0){
			fn = 36;
		}else{
			#run
		}
		setprop("instrumentation/transponder/inputs/fnposstep["~v~"]", fn);
	}else{
		# do nothing
	}

}

var mode_click_step = func (dir){
	var but_pos = getprop("instrumentation/transponder/but-pos[4]") or 0;
	var knob_mode = getprop("instrumentation/transponder/inputs/knob-mode") or 0;

	if(dir > 0){
		if(knob_mode <= 0){
			setprop("instrumentation/transponder/power-btn", 1);
			setprop("instrumentation/transponder/inputs/knob-mode", 1);
			setprop("instrumentation/transponder/but-pos[4]",38.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 29);
			setprop("instrumentation/transponder/inputs/activeline[1]", 12);
			setprop("instrumentation/transponder/inputs/activeline[2]", 35);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 1){
			setprop("instrumentation/transponder/inputs/knob-mode", 3);
			setprop("instrumentation/transponder/but-pos[4]",73.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 17);
			setprop("instrumentation/transponder/inputs/activeline[1]", 24);
			setprop("instrumentation/transponder/inputs/activeline[2]", 14);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 2){
			setprop("instrumentation/transponder/inputs/knob-mode", 3);
			setprop("instrumentation/transponder/but-pos[4]",73.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 17);
			setprop("instrumentation/transponder/inputs/activeline[1]", 24);
			setprop("instrumentation/transponder/inputs/activeline[2]", 14);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 3){
			setprop("instrumentation/transponder/inputs/knob-mode", 4);
			setprop("instrumentation/transponder/but-pos[4]",101.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 25);
			setprop("instrumentation/transponder/inputs/activeline[1]", 24);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 4){
			setprop("instrumentation/transponder/inputs/knob-mode", 5);
			setprop("instrumentation/transponder/but-pos[4]",140.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 11);
			setprop("instrumentation/transponder/inputs/activeline[1]", 22);
			setprop("instrumentation/transponder/inputs/activeline[2]", 30);
			setprop("instrumentation/transponder/inputs/activeline[3]", 16);
			setprop("instrumentation/transponder/inputs/activeline[4]", 22);
		}elsif(knob_mode == 5){
			setprop("instrumentation/transponder/inputs/knob-mode", 5);
			setprop("instrumentation/transponder/but-pos[4]",140.0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 11);
			setprop("instrumentation/transponder/inputs/activeline[1]", 22);
			setprop("instrumentation/transponder/inputs/activeline[2]", 30);
			setprop("instrumentation/transponder/inputs/activeline[3]", 16);
			setprop("instrumentation/transponder/inputs/activeline[4]", 22);
		}else{
			setprop("instrumentation/transponder/inputs/knob-mode", 0);
			setprop("instrumentation/transponder/but-pos[4]",0);
			setprop("instrumentation/transponder/power-btn", 0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 0);
			setprop("instrumentation/transponder/inputs/activeline[1]", 0);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}

	}else{

		if(knob_mode <= 1){
			setprop("instrumentation/transponder/inputs/knob-mode", 0);
			setprop("instrumentation/transponder/but-pos[4]",0);
			setprop("instrumentation/transponder/power-btn", 0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 0);
			setprop("instrumentation/transponder/inputs/activeline[1]", 0);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 2){
			setprop("instrumentation/transponder/inputs/knob-mode", 0);
			setprop("instrumentation/transponder/but-pos[4]",0);
			setprop("instrumentation/transponder/power-btn", 0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 0);
			setprop("instrumentation/transponder/inputs/activeline[1]", 0);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 3){
			setprop("instrumentation/transponder/inputs/knob-mode", 1);
			setprop("instrumentation/transponder/but-pos[4]",38);
			setprop("instrumentation/transponder/inputs/activeline[0]", 29);
			setprop("instrumentation/transponder/inputs/activeline[1]", 12);
			setprop("instrumentation/transponder/inputs/activeline[2]", 35);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 4){
			setprop("instrumentation/transponder/inputs/knob-mode", 3);
			setprop("instrumentation/transponder/but-pos[4]",73);
			setprop("instrumentation/transponder/inputs/activeline[0]", 17);
			setprop("instrumentation/transponder/inputs/activeline[1]", 24);
			setprop("instrumentation/transponder/inputs/activeline[2]", 14);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}elsif(knob_mode == 5){
			setprop("instrumentation/transponder/inputs/knob-mode", 4);
			setprop("instrumentation/transponder/but-pos[4]",101);
			setprop("instrumentation/transponder/inputs/activeline[0]", 25);
			setprop("instrumentation/transponder/inputs/activeline[1]", 24);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
		}else{
			setprop("instrumentation/transponder/inputs/knob-mode", 0);
			setprop("instrumentation/transponder/but-pos[4]",0);
			setprop("instrumentation/transponder/power-btn", 0);
			setprop("instrumentation/transponder/inputs/activeline[0]", 0);
			setprop("instrumentation/transponder/inputs/activeline[1]", 0);
			setprop("instrumentation/transponder/inputs/activeline[2]", 0);
			setprop("instrumentation/transponder/inputs/activeline[3]", 0);
			setprop("instrumentation/transponder/inputs/activeline[4]", 0);
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

var tt22_start = setlistener("/sim/signals/fdm-initialized", func {

	setprop("instrumentation/transponder/power-btn", 1);
	setprop("instrumentation/transponder/inputs/knob-mode", 1);
	setprop("instrumentation/transponder/but-pos[4]",38.0);
	setprop("instrumentation/transponder/inputs/activeline[0]", 29);
	setprop("instrumentation/transponder/inputs/activeline[1]", 12);
	setprop("instrumentation/transponder/inputs/activeline[2]", 35);
	setprop("instrumentation/transponder/inputs/activeline[3]", 0);
	setprop("instrumentation/transponder/inputs/activeline[4]", 0);
	# setprop vfr swap to 7000
	setprop("instrumentation/transponder/inputs/digit-vfr-swap[0]", 0);
	setprop("instrumentation/transponder/inputs/digit-vfr-swap[1]", 0);
	setprop("instrumentation/transponder/inputs/digit-vfr-swap[2]", 0);
	setprop("instrumentation/transponder/inputs/digit-vfr-swap[3]", 7);
	# set callsign as flight ID
	var fid = getprop("sim/multiplay/callsign");
	fid = string.replace(fid,"-","");
	fid = string.replace(fid,"_","");
	fid = string.uc(fid);
	#fid = left(fid,8);

	setprop("instrumentation/transponder/flight-id", fid);
	print(fid);
	var max = size(fid);

	for(var i=0; i < max; i+=1){
		var lettre = substr(fid, i, 1);
		var fixpos = i + (8-max);
		var l = digits_translater(lettre,-1);
		setprop("instrumentation/transponder/inputs/fnposfix["~fixpos~"]",l);
	}

	removelistener(tt22_start);
});

setlistener("instrumentation/altimeter/mode-c-alt-ft", func(state){
	if(state.getValue()){
		setprop("instrumentation/altimeter/mode-s-alt-ft", state.getValue());
	}
},1,0);
