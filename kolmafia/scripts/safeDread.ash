void main(string... args){

	boolean isScriptEnabled = get_property("betweenBattleScript") == "scripts/safeDreadPreAdventure.ash";

	if(count(args) > 0) { set_property("_safeDreadMinCount", args[0]); }

	set_property("betweenBattleScript", isScriptEnabled ? "" : "scripts/safeDreadPreAdventure.ash");
	print(isScriptEnabled ? "Pre-Adventure Script Disabled." : "Pre-Adventure Script Enabled!", "teal");
}
