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

	debug {} //FIXME: There might be another D construct to do this but this works for now.
	else
	{
		ensurePathExists(_Config.path.getConfigDir("generators"));
	}
}
