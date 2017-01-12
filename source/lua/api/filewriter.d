/**
	Provides various file writing related API functions.
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
	ApplicationPaths paths;

	if(fileName.canFind(dirSeparator))
	{
		ensurePathExists(paths.getOutputDir(), dirName(fileName));
	}

	immutable string outputFileName = buildNormalizedPath(paths.getOutputDir(), fileName);
	ensureFileExists(outputFileName, data);
}

void createGeneratorFile(const string language, const string generatorName, const string fileName, const string data)
{
	ApplicationPaths paths;

	ensurePathExists(paths.getGeneratorDirFor(language, generatorName));

	immutable string outputFileName = buildNormalizedPath(paths.getGeneratorDirFor(language, generatorName), fileName);
	ensureFileExists(outputFileName, data);
}
