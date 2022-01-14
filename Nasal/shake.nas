#################################################################################
#		Lake of Constance Hangar												#
#		Boeing 707 for Flightgear												#
#		Copyright (C) 2013 M.Kraus												#
#																				#
#		This program is free software: you can redistribute it and/or modify	#
#		it under the terms of the GNU General Public License as published by	#
#		the Free Software Foundation, either version 3 of the License, or		#
#		(at your option) any later version.										#
#																				#
#		This program is distributed in the hope that it will be useful,			#
#		but WITHOUT ANY WARRANTY; without even the implied warranty of			#
#		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the			#
#		GNU General Public License for more details.							#
#																				#
#		You should have received a copy of the GNU General Public License		#
#		along with this program.  If not, see <http://www.gnu.org/licenses/>.	#
#																				#
#		Every software has a developer, also free software. 					#
#		As a gesture of courtesy and respect, I would be delighted 				#
#		if you contacted me before making any changes to this software. 		#
#		<info (at) marc-kraus.de> April, 2017									#
#################################################################################
############################ roll out and shake effect ##################################
var shakeEffect = props.globals.initNode("rraccel/shake-effect/effect",0,"BOOL");
var shake	   = props.globals.initNode("rraccel/shake-effect/shaking",0,"DOUBLE");
var rSpeed = 0;
var sf = 0;
var ge_a_r  = 0;

var theShakeEffect = func{
		ge_a_r = getprop("gear/gear[1]/compression-norm") or 0;
		rSpeed = getprop("gear/gear[1]/rollspeed-ms") or 0;
		sf = rSpeed / 20000;
		# print("sf .... : " ~ sf);

		if(shakeEffect.getBoolValue() and ge_a_r > 0){
		  interpolate("rraccel/shake-effect/shaking", sf, 0.03);
		  settimer(func{
		  	 interpolate("rraccel/shake-effect/shaking", -sf*2, 0.03);
		  }, 0.03);
		  settimer(func{
		  	interpolate("rraccel/shake-effect/shaking", sf, 0.03);
		  }, 0.06);
			settimer(theShakeEffect, 0.09);
		}else{
		  	setprop("rraccel/shake-effect/shaking", 0);
			setprop("rraccel/shake-effect/effect",0);
		}
}
# INFORMATION: script will be startet in rraccel.nas dependend the groundspeed ############
setlistener("rraccel/shake-effect/effect", func(state){
	if(state.getBoolValue()){
		theShakeEffect();
	}
},1,0);
