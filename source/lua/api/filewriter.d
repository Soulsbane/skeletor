/**
	Provides various file writing related API functions for use with Lua.
*/
module lua.api.filewriter;

import std.stdio;
import std.path;
import std.algorithm;

import lua.api.path;

import raijin.utils.file;
import raijin.utils.path;

void createOutputFile(const string fileName, const string data)
{
	if(fileName.canFind(dirSeparator))
	{
		ensurePathExists(getOutputDir(), dirName(fileName));
	}

	immutable string outputFileName = buildNormalizedPath(getOutputDir(), fileName);
	ensureFileExists(outputFileName, data);
}

void writeLn(const(char)[][] params...)
{
	foreach(param; params)
	{
		write(param);
	}
	writeln;
}
