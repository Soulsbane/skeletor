/**
	Provides various path related API functions for use with Lua.
*/
module lua.api.path;

import std.file : exists, getcwd, thisExePath;
import std.path : dirName, buildNormalizedPath;

import raijin.utils.path;
import config;

string getInstallDir()
{
	return dirName(thisExePath());
}

string getBaseGeneratorDir()
{
	debug
	{
		return buildNormalizedPath(getInstallDir(), "generators");
	}
	else
	{
		return _Config.path.getConfigDir("generators");
	}
}

string getGeneratorLanguageDir(const string language = string.init)
{
	debug
	{
		return buildNormalizedPath(getInstallDir(), "generators", language);
	}
	else
	{
		return _Config.path.getConfigDir("generators", language);
	}
}

string getGeneratorDirFor(const string language = string.init, const string generatorName = string.init)
{
	debug
	{
		return buildNormalizedPath(getInstallDir(), "generators", language, generatorName);
	}
	else
	{
		return _Config.path.getConfigDir("generators", language, generatorName);
	}
}

string getOutputDir()
{
	return getcwd();
}

string getModuleDir()
{
	return buildNormalizedPath(getInstallDir(), "modules");
}

string getNormalizedPath(const(char)[][] params...)
{
	return buildNormalizedPath(params);
}

bool createDirInOutputDir(const string dir)
{
	return ensurePathExists(getOutputDir(), dir);
}

bool removeDirFromOutputDir(const string dir)
{
	return removePathIfExists(getOutputDir(), dir);
}
