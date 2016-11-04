module config;

import std.path : buildNormalizedPath;

import raijin.appconfig;
import raijin.configpath;
import raijin.utils.path;
import raijin.utils.file;

import luaaddon.luaconfig;

SkeletorConfig _Config;

class SkeletorConfig : LuaConfig
{
	///
	this()
	{
		configPath_ = ConfigPath("Raijinsoft", "skeletor");

		immutable string configFilePath = buildNormalizedPath(configPath_.getConfigDir("config"), "config.lua");
		immutable string importConfigString = import("default-config.lua");

		ensurePathExists(configPath_.getConfigDir("generators"));
		ensureFileExists(configFilePath, importConfigString);

		loadFile(configFilePath);
	}

	auto opDispatch(const string functionName, T...)(T args)
	{
		static if(__traits(hasMember, ConfigPath, functionName))
		{
			return mixin("configPath_." ~ functionName ~ "(args)");
		}
	}

private:
	ConfigPath configPath_;
}

static this()
{
	_Config = new SkeletorConfig;
}
