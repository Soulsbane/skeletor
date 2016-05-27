/**
	Provides various file reading related API functions for use with Lua.
*/
module lua.api.filereader;

string readText(const string fileName)
{
	import std.file : readText;
	return readText(fileName);
}

string[] getLines(const string fileName)
{
	import std.file : readText;
	import std.string : splitLines;

	return readText(fileName).splitLines();
}
