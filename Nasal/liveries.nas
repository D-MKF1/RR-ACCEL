var helmet_dialog = gui.OverlaySelector.new("Select Helmet", "/Aircraft/RR-ACCEL/Models/Pilot", "/sim/model/helmets/name", nil, "sim/multiplay/generic/string");

# This following thing will add the named propertie in the recorded variable in $HOME
aircraft.data.add("/sim/model/helmets/name");

aircraft.livery.init("Aircraft/RR-ACCEL/Models/Liveries");
