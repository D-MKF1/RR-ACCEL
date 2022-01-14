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
Doors = {};

Doors.new = func {
   obj = { parents : [Doors],
          canopy : aircraft.door.new("controls/doors/canopy", 1.0, 1)
         };
   return obj;
};

Doors.canopyopener = func {
   me.canopy.toggle();

   # if sombody open the cockpit windows in flight
   var speed = getprop("velocities/groundspeed-kt") or 0;
	 if(speed > 40){
	 	 screen.log.write("Dangerous!", 1, 0, 0);
     settimer( func { me.canopy.toggle(); setprop("controls/doors/canopy/position-norm", 0)}, 0.5);
	 }
}

# ==============
# Initialization
# ==============

# objects must be here, otherwise local to init()
doorsystem = Doors.new();
