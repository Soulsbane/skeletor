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
