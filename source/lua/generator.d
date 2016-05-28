module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;

import luad.all;

import lua.api.path;
import lua.api.filereader;
import lua.api.filewriter;
import lua.api.fileutils;

struct LuaGenerator
{
	this(const string language, const string generatorName)
	{
		language_ = language;
		generatorName_ = generatorName;

		lua_ = new LuaState;
		lua_.openLibs();
		lua_.setPanicHandler(&panic);

		setupAPIFunctions();
		setupPackagePaths();
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio : writeln;
		writeln("Error in generator code!\n", error, "\n");
	}

	bool create()
	{
		immutable string fileName = buildNormalizedPath(getGeneratorDir(), generatorName_) ~ ".lua";

		if(fileName.exists)
		{
			auto addonFile = lua_.loadFile(fileName);
			addonFile(); // INFO: We could pass arguments to the file via ... could be useful in the future.

			callFunction("OnCreate");
			return true;
		}

		return false;
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
		lua_["Globals"] = lua_.newTable;

		lua_["FileReader"] = lua_.newTable;
		lua_["FileReader", "ReadText"] = &lua.api.filereader.readText;
		lua_["FileReader", "GetLines"] = &lua.api.filereader.getLines;

		lua_["FileWriter"] = lua_.newTable;
		lua_["FileWriter", "CreateOutputFile"] = &lua.api.filewriter.createOutputFile;

		lua_["FileUtils"] = lua_.newTable;
		lua_["FileUtils", "CopyFileTo"] = &lua.api.fileutils.copyFileTo;
		lua_["FileUtils", "CopyFileToOutputDir"] = &lua.api.fileutils.copyFileToOutputDir;
		lua_["FileUtils", "RemoveFileFromOutputDir"] = &lua.api.fileutils.removeFileFromOutputDir;
		/*lua_["FileUtils", "RemoveFileFromAddonDir"] = &api.fileutils.removeFileFromAddonDir;
		lua_["FileUtils", "RegisterFileForRemoval"] = &api.fileutils.registerFileForRemoval;
*/
		lua_["Path"] = lua_.newTable;
		lua_["Path", "GetBaseGeneratorDir"] = &lua.api.path.getBaseGeneratorDir;
		lua_["Path", "GetGeneratorDirFor"] = &lua.api.path.getGeneratorDirFor;
		lua_["Path", "GetGeneratorDir"] = &getGeneratorDir;
		lua_["Path", "GetGeneratorLanguageDir"] = &lua.api.path.getGeneratorLanguageDir;
		lua_["Path", "GetOutputDir"] = &lua.api.path.getOutputDir;
		lua_["Path", "GetGeneratorModuleDir"] = &getGeneratorModuleDir;
		lua_["Path", "GetModuleDir"] = &lua.api.path.getModuleDir;
		lua_["Path", "Normalize"] = &lua.api.path.getNormalizedPath;
	}

	// May need to be static. This requires for testing on the lua side.
	string getGeneratorDir()
	{
		return getGeneratorDirFor(language_, generatorName_);
	}

	string getGeneratorModuleDir()
	{
		return buildNormalizedPath(getGeneratorDir(), "modules");
	}

	void setupPackagePaths()
	{
		import std.path : buildNormalizedPath;
		string packagePath = buildNormalizedPath(getInstallDir(), "modules", "?.lua");

		packagePath ~= ";" ~ buildNormalizedPath(getGeneratorDirFor(language_, generatorName_), "modules", "?.lua");
		lua_["package", "path"] = packagePath;
	}

private:
	LuaState lua_;
	string language_;
	string generatorName_;
}
