module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;

import raijin.utils.file;
import luad.all;

import config;
import inputcollector;
import lua.api.path;
import lua.api.filereader;
import lua.api.filewriter;
import lua.api.fileutils;

enum DEFAULT_PROMPTS_FILE_STRING = import("default-prompts.lua");
enum DEFAULT_INIT_FILE_STRING = import("default-init.lua");

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

		loadAndExecuteLuaFile(DEFAULT_INIT_FILE_STRING, "init.lua");
	}

	~this()
	{
		callFunction("OnDestroy");
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

			loadAndExecuteLuaFile(DEFAULT_PROMPTS_FILE_STRING, "prompts.lua");
			addonFile(); // INFO: We could pass arguments to the file via ... could be useful in the future.
			callFunction("OnCreate");

			return true;
		}

		return false;
	}

	void processInput()
	{
		CollectedValues values = collectValues();

		foreach(key, value; values)
		{
			lua_[key] = value;
		}

		callFunction("OnProcessInput", values);
	}

	void callFunction(T...)(const string name, T args)
	{
		if(hasFunction(name))
		{
			lua_.get!LuaFunction(name)(args);
		}
	}

	bool hasFunction(const string name)
	{
		return lua_[name].isNil ? false : true;
	}

private:
	public void loadAndExecuteLuaFile(const string defaultFileString, const string generatedFileName)
	{
		immutable string defaultString = defaultFileString;

		debug
		{
			auto loadedFile = lua_.loadString(defaultString);
			loadedFile();
		}
		else
		{
			immutable string generatedFilePath = buildNormalizedPath(_Config.getConfigDir("config"), generatedFileName);

			ensureFileExists(generatedFilePath, defaultString);
			auto loadedFile = lua_.loadFile(generatedFilePath);
			loadedFile();
		}
	}

	void setupAPIFunctions()
	{
		lua_["IO"] = lua_.newTable;
		lua_["IO", "ReadText"] = &lua.api.filereader.readText;
		lua_["IO", "GetLines"] = &lua.api.filereader.getLines;

		lua_["IO", "CreateOutputFile"] = &lua.api.filewriter.createOutputFile;

		lua_["IO", "CopyFileTo"] = &lua.api.fileutils.copyFileTo;
		lua_["IO", "CopyFileToOutputDir"] = &lua.api.fileutils.copyFileToOutputDir;
		lua_["IO", "RemoveFileFromOutputDir"] = &lua.api.fileutils.removeFileFromOutputDir;

		lua_["Input"] = lua_.newTable;
		lua_["Input", "UserInputPrompt"] = &inputcollector.userInputPrompt;

		lua_["Path"] = lua_.newTable;
		lua_["Path", "GetBaseGeneratorDir"] = &lua.api.path.getBaseGeneratorDir;
		lua_["Path", "GetGeneratorDirFor"] = &lua.api.path.getGeneratorDirFor;
		lua_["Path", "GetGeneratorDir"] = &getGeneratorDir;
		lua_["Path", "GetGeneratorLanguageDir"] = &lua.api.path.getGeneratorLanguageDir;
		lua_["Path", "GetOutputDir"] = &lua.api.path.getOutputDir;
		lua_["Path", "GetGeneratorModulesDir"] = &getGeneratorModulesDir;
		lua_["Path", "GetModuleDir"] = &lua.api.path.getModuleDir;
		lua_["Path", "GetGeneratorTemplatesDir"] = &getGeneratorTemplatesDir;
		lua_["Path", "Normalize"] = &lua.api.path.getNormalizedPath;
	}

	void setupPackagePaths()
	{
		string packagePath = buildNormalizedPath(getInstallDir(), "modules", "?.lua");

		packagePath ~= ";" ~ buildNormalizedPath(getGeneratorDirFor(language_, generatorName_), "modules", "?.lua");
		lua_["package", "path"] = packagePath;
	}

	string getGeneratorDir()
	{
		return getGeneratorDirFor(language_, generatorName_);
	}

	string getGeneratorModulesDir()
	{
		return buildNormalizedPath(getGeneratorDir(), "modules");
	}

	string getGeneratorTemplatesDir()
	{
		return buildNormalizedPath(getGeneratorDir(), "templates");
	}

private:
	LuaState lua_;
	string language_;
	string generatorName_;
}
