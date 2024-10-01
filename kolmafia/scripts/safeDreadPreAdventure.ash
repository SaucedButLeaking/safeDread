// Globals

// number of monsters to leave alive in a zone

int protecc = property_exists("_safeDreadMinCount") ? get_property("_safeDreadMinCount").to_int() : 10;

// boolean rundown = false;
// sanity check counter to make sure the number of monsters remaining matches what we expect it to be
// int[string] left = {"Forest": 1000, "Village": 1000, "Castle": 1000};

// set_property("_safeDread_clan","ASS");

//function to initialize our preferences

// Function to clear us to proceed
void safeToContinue(string zone) {
	// Check the dungeon logs, parse out the monsters left in this zone
	string raidLogs = visit_url("clan_raidlogs.php");
	 
	matcher checkLeft = create_matcher(`<center>Your clan has defeated <b>(1?,?\\d+)</b> monster\\(s\\) in the {zone}`, raidLogs);
	

	if (checkLeft.find()) {
		int remaining = 1000 - to_int(checkLeft.group(1));

		print("There are " + remaining + " monsters left in the " + zone,"green");


		if (remaining <= protecc){
			abort("Your next adventure would bring " + get_clan_name() + " down below " + to_string(protecc) + " monsters in the " + zone + "! Aborting!");
		}

		// logic to make sure we're not adventuring at the same time as anyone else

		int startIndex = raidLogs.index_of(`The {zone}`);
		string[string] endIndexText = {"Village":"The Woods", "Woods":"The Castle", "Castle":"Miscellaneous"};
		int endIndex = raidLogs.index_of(endIndexText[zone]);
		// Find the start and the end of the raidlogs zone portions


		raidLogs = raidLogs.substring(startIndex, endIndex).to_lower_case();
		matcher selfMatcher = create_matcher(`{my_name()}.*?<br>`, raidLogs);	// ny_name() returns all lowercase, and a whois() on my_id() is a server hit which really sucks but oh well
		raidlogs = replace_all(selfMatcher, "");
		// Replace all instances of your name.* with blanks

		string[int] temp;
		file_to_map("safeDreadData.txt", temp); 
		// Take previous turn data

		if(temp[0] != raidlogs && temp[0] != ""){
			clear(temp);
			map_to_file(temp, "safeDreadData.txt");

			abort("Someone else is adventuring at the same time as you!"); // Clear data to prevent softlocks
		}
		// Compare previous turn data with current turn data. If there's any change, it's not from your username and therefore someone else. Unless it's your first adv, then skip

		temp[0] = raidlogs;	
		map_to_file(temp, "safeDreadData.txt");
		// Save current turn data
		return;
		
	}

	abort("It doesn't look like dreadsylania is open in " + get_clan_name());
}


void main() {
	// print(to_string(my_location()));		


	
	string zone = substring(my_location(), my_location().index_of(" ") + 1);

	// TODO add a time-based clear system 
	
	string[int] temp;
	file_to_map("safeDreadData.txt", temp);

	if(temp[0] == ""){
		// skip
	} else if(temp[0].substring(temp[0].index_of(" ") + 1, temp[0].index_of("</b>")) != zone.to_lower_case()){		
		
		print("Resetting data as we have swapped zones.", "lime");
		temp[0] = "";
		map_to_file(temp, "safeDreadData.txt");
	}
	// Are we swapping zones? If so, reset safeDreadData.txt


	safeToContinue(zone == "Woods" ? "Forest" : zone);
}
