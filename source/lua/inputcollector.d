/**
	Handles the processing of values inputted by the user.
*/
module inputcollector;

import std.typecons;
import std.stdio;
import std.string;

alias CollectedValues = Tuple!(string, "author", string, "description");

string userInputPrompt(const string msg, string defaultValue = string.init)
{
	write(msg);
	string input = readln();

	if(input == "\x0a") // Only enter was pressed use the default value instead.
	{
		input = defaultValue;
	}

	return input.strip;
}

CollectedValues collectValues()
{
	CollectedValues values;

	values.author = userInputPrompt("Author: ", "Paul Crane");
	values.description = userInputPrompt("Description: ");

	return values;
}
