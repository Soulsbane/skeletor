module lua.generator;

import luad.all;

import lua.api.path;

struct LuaGenerator
{
	this(const string language, const string generatorName)
	{
		language_ = language;
		generatorName_ = generatorName;

		lua_ = new LuaState;
		lua_.openLibs();
		lua_.setPanicHandler(&panic);
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio : writeln;
		writeln("Error in generator code!\n", error, "\n");
	}

	void callFunction(const string name)
	{
		if(hasFunction(name))
		{
			lua_.get!LuaFunction(name)();
		}
	}

	bool hasFunction(const string name)
	{
		return lua_[name].isNil ? false : true;
	}

private:
	void setupAPIFunctions()
	{
		/*lua_["AppConfig"] = lua_.newTable;

		lua_["FileReader"] = lua_.newTable;
		lua_["FileReader", "ReadText"] = &api.filereader.readText;
		lua_["FileReader", "GetLines"] = &api.filereader.getLines;

		lua_["FileUtils"] = lua_.newTable;
		lua_["FileUtils", "CopyFileTo"] = &api.fileutils.copyFileTo;
		lua_["FileUtils", "CopyFileToOutputDir"] = &api.fileutils.copyFileToOutputDir;
		lua_["FileUtils", "RemoveFileFromAddonDir"] = &api.fileutils.removeFileFromAddonDir;
		lua_["FileUtils", "RemoveFileFromOutputDir"] = &api.fileutils.removeFileFromOutputDir;
		lua_["FileUtils", "RegisterFileForRemoval"] = &api.fileutils.registerFileForRemoval;
*/
		lua_["Path"] = lua_.newTable;
		lua_["Path", "GetGeneratorDir"] = &lua.api.path.getGeneratorDir;
		lua_["Path", "GetGeneratorLanguageDir"] = &lua.api.path.getGeneratorLanguageDir;
		lua_["Path", "GetGeneratorDirFor"] = &lua.api.path.getGeneratorDirFor;
		lua_["Path", "GetOutputDir"] = &lua.api.path.getOutputDir;
	}

private:
	LuaState lua_;
	string language_;
	string generatorName_;
}
