module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;
import std.datetime : Clock;

import raijin.utils.file;
import raijin.cmdline;
import raijin.utils.debugtools;
import luad.all;

import config;
import inputcollector;

import lua.luaaddon;
import lua.api.path;
import lua.api.filereader;
import lua.api.filewriter;
import lua.api.fileutils;
import lua.api.downloader;

struct LuaGenerator
{
	enum DEFAULT_PROMPTS_FILE_STRING = import("default-prompts.lua");
	enum DEFAULT_INIT_FILE_STRING = import("default-init.lua");

	void setupLuaEnv()
	{
		lua_.setupEnvironment();

		setupAPIFunctions();
		setupPackagePaths();
		setupGlobalTemplateVars();

		loadDefaultModules();
		loadAndExecuteLuaFile(DEFAULT_INIT_FILE_STRING, "init.lua");
	}

	~this()
	{
		if(generatorLoaded_)
		{
			lua_.callFunction("OnDestroy");
		}
	}

	bool create(const string language, const string generatorName)
	{
		//Log.info("start"); //FIXME: This keeps us from segfaulting for some reason?
		immutable string fileName = buildNormalizedPath(getGeneratorDirFor(language, generatorName), generatorName) ~ ".lua";

		if(fileName.exists)
		{
			language_ = language;
			generatorName_ = generatorName;
			generatorLoaded_ = true;

			setupLuaEnv();

			//inputcollector.userInputPrompt("ProjectName", "Project Name(Used as directory name as well): ", "foobar");
			auto addonFile = lua_.loadFile(fileName);

			loadAndExecuteLuaFile(DEFAULT_PROMPTS_FILE_STRING, "prompts.lua");
			addonFile(); // INFO: We could pass arguments to the file via ... could be useful in the future.

			lua_.callFunction("OnCreate");

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

		lua_.callFunction("OnProcessInput", values);
	}

private:
	void loadDefaultModules()
	{
		auto templateModule = lua_.loadFile(buildNormalizedPath(getModuleDir(), "resty", "template.lua"));
		templateModule();
	}

	void loadAndExecuteLuaFile(const string defaultFileString, const string generatedFileName)
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
		lua_["Helpers"] = lua_.newTable; // Helpers table is used in Helpers Lua module

		lua_["IO"] = lua_.newTable;
		lua_["IO", "ReadText"] = &lua.api.filereader.readText;
		lua_["IO", "GetLines"] = &lua.api.filereader.getLines;

		lua_["IO", "CreateOutputFile"] = &lua.api.filewriter.createOutputFile;

		lua_["IO", "CopyFileTo"] = &lua.api.fileutils.copyFileTo;
		lua_["IO", "CopyFileToOutputDir"] = &lua.api.fileutils.copyFileToOutputDir;
		lua_["IO", "RemoveFileFromOutputDir"] = &lua.api.fileutils.removeFileFromOutputDir;

		lua_["UserInput"] = lua_.newTable;
		lua_["UserInput", "HasValueFor"] = &inputcollector.hasValueFor;
		lua_["UserInput", "GetValueFor"] = &inputcollector.getValueFor;
		lua_["UserInput", "Prompt"] = &inputcollector.userInputPrompt;
		lua_["UserInput", "ConfirmationPrompt"] = &raijin.cmdline.confirmationPrompt;

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
		lua_["Path", "CreateDirInOutputDir"] = &lua.api.path.createDirInOutputDir;
		lua_["Path", "RemoveDirFromOutputDir"] = &lua.api.path.removeDirFromOutputDir;
		lua_["Path", "DirExists"] = &lua.api.path.dirExists;
		lua_["Path", "OutputDirExists"] = &lua.api.path.outputDirExists;

		lua_["Downloader"] = lua_.newTable;
		lua_["Downloader", "GetTextFile"] = &lua.api.downloader.getTextFile;
	}

	void setupPackagePaths()
	{
		string packagePath = buildNormalizedPath(getInstallDir(), "modules", "?.lua");

		packagePath ~= ";" ~ buildNormalizedPath(getGeneratorDirFor(language_, generatorName_), "modules", "?.lua");
		lua_["package", "path"] = packagePath;
	}

	void setupGlobalTemplateVars()
	{
		auto currentTime = Clock.currTime;
		int hour = cast(int)currentTime.hour;

		if(hour > 12)
		{
			hour = hour - 12;
		}

		lua_["Month"] = currentTime.month;
		lua_["Day"] = currentTime.day;
		lua_["Year"] = currentTime.year;
		lua_["Hour"] = hour;
		lua_["Hour24"] = currentTime.hour;
		lua_["Minute"] = currentTime.minute;
		lua_["Second"] = currentTime.second;
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
	LuaAddon lua_;
	string language_;
	string generatorName_;
	bool generatorLoaded_;
}
