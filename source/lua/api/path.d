/**
	Provides various API functions for use with Lua.
*/
module lua.api.path;

import std.file : getcwd, thisExePath;
import std.path : dirName;

import raijin;

AppConfig _Config;

static this()
{
	immutable string defaultConfigFileData = import("default-app.config");
	_Config = AppConfig("Raijinsoft", "skeletor", defaultConfigFileData);

	ensurePathExists(getBaseGeneratorDir());
}

string getInstallDir()
{
	return dirName(thisExePath());
}

string getBaseGeneratorDir()
{
	return _Config.path.getConfigDir("generators");
}

string getGeneratorLanguageDir(const string language = string.init)
{
	return _Config.path.getConfigDir("generators", language);
}

string getGeneratorDirFor(const string language = string.init, const string generatorName = string.init)
{
	return _Config.path.getConfigDir("generators", language, generatorName);
}

string getOutputDir()
{
	return getcwd();
}
