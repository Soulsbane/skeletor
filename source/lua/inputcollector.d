/**
	Handles the processing of values inputted by the user.
*/
module inputcollector;

import std.typecons;
import std.stdio;
import std.string;

alias CollectedValues = string[string];
private CollectedValues _Values;

string userInputPrompt(const string globalVarName, const string msg, string defaultValue = string.init)
{
	write(msg);
	string input = readln();

	if(input == "\x0a") // Only enter was pressed use the default value instead.
	{
		input = defaultValue;
	}

	_Values[globalVarName] = input.strip;

	return input.strip;
}

CollectedValues collectValues()
{
	userInputPrompt("Author", "Author: ", "Paul Crane");
	userInputPrompt("Description", "Description: ");

	return _Values;
}
