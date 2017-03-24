module config;

import std.path : buildNormalizedPath;

import dpathutils;
import dfileutils;
import raijin.utils.path;

import luaaddon.luaconfig;

SkeletorConfig _Config;

class SkeletorConfig : LuaConfig
{
	///
	this()
	{
		configPath_ = ConfigPath("Raijinsoft", "skeletor");

		immutable string configFilePath = buildNormalizedPath(configPath_.getDir("config"), "config.lua");
		immutable string importConfigString = import("default-config.lua");

		ensurePathExists(configPath_.getDir("config"));
		ensurePathExists(configPath_.getDir("generators"));
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
