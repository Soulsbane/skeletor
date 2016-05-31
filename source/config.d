module config;

import std.path : dirName, buildNormalizedPath;
import std.file : thisExePath;

import raijin.appconfig;
import raijin.utils.path;

AppConfig _Config;

static this()
{
	immutable string defaultConfigFileData = import("default-app.config");
	_Config = AppConfig("Raijinsoft", "skeletor", defaultConfigFileData);

	debug
	{
		ensurePathExists(buildNormalizedPath(dirName(thisExePath()), "generators"));
	}
	else
	{
		ensurePathExists(_Config.path.getConfigDir("generators"));
	}
}
