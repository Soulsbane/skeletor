module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;

import raijin.utils.file;
import luad.all;

import inputcollector;
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

		//TODO: Load init.lua(or another name) that will handle the default input instead of being hardcoded in D.
		//auto initFile = lua_.loadFile(_Config.getConfigDir("config") ~ "init.lua");
		//initFile();
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
		//FIXME: Generator won't be found in release mode yet since it isn't extracted.

		if(fileName.exists)
		{
			auto addonFile = lua_.loadFile(fileName);

			loadPromptsFile();
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

	void callFunction(const string name)
	{
		if(hasFunction(name))
		{
			lua_.get!LuaFunction(name)();
		}
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

	void loadPromptsFile()
	{
		immutable string defaultPromptsFile = import("default-prompts.lua");

		debug
		{
			auto promptsFile = lua_.loadString(defaultPromptsFile);
			promptsFile(); // Handles the default prompts(Author, Description etc.)
		}
		else
		{
			immutable string promptsFilePath = buildNormalizedPath(_Config.getConfigDir("config"), "prompts.lua");

			ensureFileExists(promptsFilePath, defaultPromptsFile);
			auto promptsFile = lua_.loadFile(promptsFilePath);
			promptsFile(); // Handles the default prompts(Author, Description etc.)
		}
	}

	void setupAPIFunctions()
	{
		lua_["FileReader"] = lua_.newTable;
		lua_["FileReader", "ReadText"] = &lua.api.filereader.readText;
		lua_["FileReader", "GetLines"] = &lua.api.filereader.getLines;

		lua_["FileWriter"] = lua_.newTable;
		lua_["FileWriter", "CreateOutputFile"] = &lua.api.filewriter.createOutputFile;

		lua_["FileUtils"] = lua_.newTable;
		lua_["FileUtils", "CopyFileTo"] = &lua.api.fileutils.copyFileTo;
		lua_["FileUtils", "CopyFileToOutputDir"] = &lua.api.fileutils.copyFileToOutputDir;
		lua_["FileUtils", "RemoveFileFromOutputDir"] = &lua.api.fileutils.removeFileFromOutputDir;

		lua_["Input"] = lua_.newTable;
		lua_["Input", "UserInputPrompt"] = &inputcollector.userInputPrompt;

		lua_["Path"] = lua_.newTable;
		lua_["Path", "GetBaseGeneratorDir"] = &lua.api.path.getBaseGeneratorDir;
		lua_["Path", "GetGeneratorDirFor"] = &lua.api.path.getGeneratorDirFor;
		lua_["Path", "GetGeneratorDir"] = &getGeneratorDir;
		lua_["Path", "GetGeneratorLanguageDir"] = &lua.api.path.getGeneratorLanguageDir;
		lua_["Path", "GetOutputDir"] = &lua.api.path.getOutputDir;
		lua_["Path", "GetGeneratorModuleDir"] = &getGeneratorModuleDir;
		lua_["Path", "GetModuleDir"] = &lua.api.path.getModuleDir;
		lua_["Path", "GetGeneratorTemplatesDir"] = &getGeneratorTemplatesDir;
		lua_["Path", "Normalize"] = &lua.api.path.getNormalizedPath;
	}

	void setupPackagePaths()
	{
		import std.path : buildNormalizedPath;
		string packagePath = buildNormalizedPath(getInstallDir(), "modules", "?.lua");

		packagePath ~= ";" ~ buildNormalizedPath(getGeneratorDirFor(language_, generatorName_), "modules", "?.lua");
		lua_["package", "path"] = packagePath;
	}

	string getGeneratorDir()
	{
		return getGeneratorDirFor(language_, generatorName_);
	}

	string getGeneratorModuleDir()
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
