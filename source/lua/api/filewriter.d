/**
	Provides various file writing related API functions for use with Lua.
*/
module lua.api.filewriter;

import std.path : buildNormalizedPath;

import lua.api.path;
import raijin.utils.file;

void createOutputFile(const string fileName, const string data)
{
	immutable string outputFileName = buildNormalizedPath(getOutputDir(), fileName);
	ensureFileExists(outputFileName, data);
}
