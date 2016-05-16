/**
	Provides various API functions for use with Lua.
*/
module lua.api;

import raijin;

AppConfig _Config;

static this()
{
	immutable string defaultConfigFileData = import("default-app.config");
	_Config = AppConfig("Raijinsoft", "skeletor", defaultConfigFileData);

	ensurePathExists(getTemplatesPath());
}

string getTemplatesPath(const string language = string.init)
{
	return _Config.path.getConfigDir("templates", language);
}
