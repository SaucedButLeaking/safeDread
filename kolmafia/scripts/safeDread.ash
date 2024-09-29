void main(){
	boolean isScriptEnabled = get_property("preAdventureScript") == "scripts/safeDreadPreAdventure.ash";

	set_property("preAdventureScript", isScriptEnabled ? "" : "scripts/safeDreadPreAdventure.ash");
	print(isScriptEnabled ? "Pre-Adventure Script Disabled." : "Pre-Adventure Script Enabled!", "teal");
}
