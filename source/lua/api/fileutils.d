/**
	Provides various file utility related API functions for use with Lua.
*/
module lua.api.fileutils;

import std.file : copy, PreserveAttributes, getcwd, exists, remove;
import std.path : baseName, buildNormalizedPath;

import raijin.utils.file : removeFileIfExists;
import lua.api.path : getOutputDir;

void copyFileTo(string from, string to) @trusted
{
	copy(from, to, PreserveAttributes.yes);
}

void copyFileToOutputDir(string fileName) @trusted
{
	copy(fileName, buildNormalizedPath(getcwd(), baseName(fileName)), PreserveAttributes.yes);
}

void removeFileFromOutputDir(string fileName) @trusted
{
	string file = buildNormalizedPath(getOutputDir(), fileName);
	removeFileIfExists(file);
}

bool dirExists(string dir)
{
	return dir.exists;
}

bool outputDirExists(string dir)
{
	string file = buildNormalizedPath(getOutputDir(), dir);
	return file.exists;
}
