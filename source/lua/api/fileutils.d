module lua.api.fileutils;

import std.file : copy, PreserveAttributes, getcwd, exists, remove;
import std.path : baseName, buildNormalizedPath;
import raijin.utils.file : removeFileIfExists;

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
	import lua.api.path : getOutputDir;
	string file = buildNormalizedPath(getOutputDir(), fileName);

	removeFileIfExists(file);
}
