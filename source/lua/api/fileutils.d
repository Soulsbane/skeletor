module lua.api.fileutils;

import std.file : copy, PreserveAttributes, getcwd;
import std.path : baseName, buildNormalizedPath;

void copyFileTo(string from, string to) @trusted
{
	copy(from, to, PreserveAttributes.yes);
}

void copyFileToOutputDir(string fileName) @trusted
{
	copy(fileName, buildNormalizedPath(getcwd(), baseName(fileName)), PreserveAttributes.yes);
}
