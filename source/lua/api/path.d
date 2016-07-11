/**
	Provides various path related API functions for use with Lua.
*/
module lua.api.path;

import std.file : exists, getcwd, thisExePath;
import std.path : dirName, buildNormalizedPath;
import std.stdio;

import luad.all;
import raijin.utils.path;
import config;
import lua.helpers;

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
	debug
	{
		return buildNormalizedPath(getInstallDir(), "modules");
	}
	else
	{
		return _Config.path.getConfigDir("modules");
	}
}

string getNormalizedPath(LuaObject[] params...)
{
	return buildNormalizedPath(params.convertLuaObjectsToStrings);
}

bool createDirInOutputDir(LuaObject[] params...)
{
	immutable string path = buildNormalizedPath(params.convertLuaObjectsToStrings);
	return ensurePathExists(getOutputDir(), path);
}

bool removeDirFromOutputDir(const string dir)
{
	return removePathIfExists(getOutputDir(), dir);
}
