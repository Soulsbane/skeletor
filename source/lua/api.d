/**
	Provides various API functions for use with Lua.
*/
module lua.api;

import raijin.appconfig;

AppConfig _Config;

static this()
{
	immutable string defaultConfigFileData = import("default-app.config");
	_Config = AppConfig("Raijinsoft", "skeletor", defaultConfigFileData);
}
