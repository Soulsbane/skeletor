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
import inputcollector;

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
		return _Config.getConfigDir("generators");
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
		return _Config.getConfigDir("generators", language);
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
		return _Config.getConfigDir("generators", language, generatorName);
	}
}

string getOutputDir()
{
	//return getcwd();
	return buildNormalizedPath(getcwd(), getValueFor("ProjectName"));
}

string getModuleDir()
{
	debug
	{
		return buildNormalizedPath(getInstallDir(), "modules");
	}
	else
	{
		return _Config.getConfigDir("modules");
	}
}

string getTemplatesDir()
{
	debug
	{
		return buildNormalizedPath(getInstallDir(), "templates");
	}
	else
	{
		return _Config.getConfigDir("templates");
	}
}

string getNormalizedPath(const(char)[][] params...)
{
	return buildNormalizedPath(params);
}

bool createDirInOutputDir(const(char)[][] params...)
{
	immutable string path = buildNormalizedPath(params);
	return ensurePathExists(buildNormalizedPath(getOutputDir(), path));
}

bool removeDirFromOutputDir(const string dir)
{
	return removePathIfExists(getOutputDir(), dir);
}

bool dirExists(const string dir)
{
	return dir.exists;
}

bool outputDirExists(const string dir)
{
	string file = buildNormalizedPath(getOutputDir(), dir);
	return file.exists;
}
