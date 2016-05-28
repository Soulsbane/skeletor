/**
	Handles the processing of values inputted by the user.
*/
module inputcollector;

import std.typecons : Tuple;
import std.stdio : write, readln;

alias CollectedValues = Tuple!(string, "author", string, "description");

CollectedValues collectValues()
{
	CollectedValues values;

	write("Author: ");
	values.author = readln();

	write("Description: ");
	values.description = readln();

	return values;
}
