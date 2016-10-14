module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;
import std.datetime : Clock;
import std.typecons : scoped;

import raijin.utils.file;
import raijin.cmdline;
import raijin.utils.debugtools;
import luad.all;

import config;
import inputcollector;

import lua.api;
import luaaddon;

alias MakeLuaGenerator = scoped!LuaGenerator;

class LuaGenerator : LuaAddon
{
	private enum DEFAULT_PROMPTS_FILE_STRING = import("default-prompts.lua");
	private enum DEFAULT_INIT_FILE_STRING = import("default-init.lua");

	void setupLuaEnv()
	{
		setupAPIFunctions();
		setupPackagePaths();

		loadDefaultModules();
		loadAndExecuteLuaFile(DEFAULT_INIT_FILE_STRING, "init.lua");
	}

	void destroy()
	{
		if(generatorLoaded_)
		{
			callFunction("OnDestroy");
		}
	}

	bool create(const string language, const string generatorName)
	{
		immutable string fileName = buildNormalizedPath(getGeneratorDirFor(language, generatorName), generatorName) ~ ".lua";

		if(fileName.exists)
		{
			language_ = language;
			generatorName_ = generatorName;

			immutable string tocFileName = buildNormalizedPath(getGeneratorDir(), generatorName) ~ ".toc";
			immutable bool hasToc = toc_.loadFile(tocFileName);

			generatorLoaded_ = true;

			mainTable_ = state_.newTable;
			setupLuaEnv();

			if(hasToc)
			{
				loadTocFiles();
			}

			loadFile(fileName, mainTable_);
			callFunction("OnCreate");
			loadAndExecuteLuaFile(DEFAULT_PROMPTS_FILE_STRING, "prompts.lua");

			return true;
		}

		return false;
	}

	void processInput()
	{
		//callFunction("OnCollectValues"); // FIXMEP: Enable later?
		CollectedValues values = collectValues();

		foreach(key, value; values)
		{
			state_[key] = value.value;
		}

		callFunction("OnProcessInput", values);
	}

private:
	void loadDefaultModules()
	{
		doFile(buildNormalizedPath(getModuleDir(), "resty", "template.lua"));
		doFile(buildNormalizedPath(getModuleDir(), "globals.lua"));
	}

	void loadAndExecuteLuaFile(const string defaultFileString, const string generatedFileName)
	{
		immutable string defaultString = defaultFileString;

		debug
		{
			doString(defaultString);
		}
		else
		{
			immutable string generatedFilePath = buildNormalizedPath(_Config.getConfigDir("config"), generatedFileName);

			ensureFileExists(generatedFilePath, defaultString);
			doFile(generatedFilePath);
		}
	}

	void loadTocFiles()
	{
		foreach(file; toc_.getFilesList())
		{
			loadFile(buildNormalizedPath(getGeneratorDir(), file), mainTable_);
		}
	}

	void setupAPIFunctions()
	{
		createTable("Helpers", "IO", "UserInput", "Path", "Downloader");

		registerFunction("IO", "ReadText", &readText);
		registerFunction("IO", "GetLines", &getLines);
		registerFunction("IO", "CreateOutputFile", &createOutputFile);
		registerFunction("IO", "CopyFileTo", &copyFileTo);
		registerFunction("IO", "CopyFileToOutputDir", &copyFileToOutputDir);
		registerFunction("IO", "RemoveFileFromOutputDir", &removeFileFromOutputDir);

		registerFunction("UserInput", "HasValueFor", &hasValueFor);
		registerFunction("UserInput", "GetValueFor", &getValueFor);
		registerFunction("UserInput", "EnablePrompt", &enablePrompt);
		registerFunction("UserInput", "DisablePrompt", &disablePrompt);
		registerFunction("UserInput", "Prompt", &userInputPrompt);
		registerFunction("UserInput", "ConfirmationPrompt", &confirmationPrompt);

		registerFunction("Path", "GetBaseGeneratorDir", &getBaseGeneratorDir);
		registerFunction("Path", "GetGeneratorDirFor", &getGeneratorDirFor);
		registerFunction("Path", "GetGeneratorDir", &getGeneratorDir);
		registerFunction("Path", "GetGeneratorLanguageDir", &getGeneratorLanguageDir);
		registerFunction("Path", "GetOutputDir", &getOutputDir);
		registerFunction("Path", "GetGeneratorModulesDir", &getGeneratorModulesDir);
		registerFunction("Path", "GetModuleDir", &getModuleDir);
		registerFunction("Path", "GetGeneratorTemplatesDir", &getGeneratorTemplatesDir);
		registerFunction("Path", "Normalize", &getNormalizedPath);
		registerFunction("Path", "CreateDirInOutputDir", &createDirInOutputDir);
		registerFunction("Path", "RemoveDirFromOutputDir", &removeDirFromOutputDir);
		registerFunction("Path", "DirExists", &dirExists);
		registerFunction("Path", "OutputDirExists", &outputDirExists);

		registerFunction("Downloader", "GetTextFile", &getTextFile);
	}

	void setupPackagePaths()
	{
		immutable string baseModulePath = buildNormalizedPath(getInstallDir(), "modules");
		immutable string genModulePath = buildNormalizedPath(getGeneratorDirFor(language_, generatorName_), "modules");

		registerPackagePaths(baseModulePath, genModulePath);
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
	string language_;
	string generatorName_;
	bool generatorLoaded_;
	TocParser toc_;
	LuaTable mainTable_;
}
