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

	ensurePathExists(getGeneratorPath());
}

string getGeneratorPath()
{
	return _Config.path.getConfigDir("generators");
}

string getGeneratorLanguagePath(const string language = string.init)
{
	return _Config.path.getConfigDir("generators", language);
}

string getGeneratorPathFor(const string language = string.init, const string generatorName = string.init)
{
	return _Config.path.getConfigDir("generators", language, generatorName);
}
