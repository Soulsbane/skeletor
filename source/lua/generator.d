module lua.generator;

import std.path : buildNormalizedPath;
import std.file : exists;
import std.typecons : scoped;
import std.stdio : writeln;

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

	void create(const string language, const string generatorName)
	{
		immutable string fileName = buildNormalizedPath(paths_.getGeneratorDirFor(language, generatorName), generatorName) ~ ".lua";

		if(fileName.exists)
		{
			language_ = language;
			generatorName_ = generatorName;
			paths_.setLanguageAndGeneratorName(language, generatorName);

			immutable string tocFileName = buildNormalizedPath(paths_.getGeneratorDir(), generatorName) ~ ".toc";
			immutable bool hasToc = toc_.loadFile(tocFileName);

			generatorLoaded_ = true;

			mainTable_ = state_.newTable;
			setupLuaEnv();

			if(hasToc)
			{
				immutable size_t appVersion = getAPIVersion();
				immutable size_t generatorVersion = toc_.getValue!size_t("API-Version", appVersion);

				if(generatorVersion < appVersion)
				{
					throw new Exception("This generator is incompatible with this version of skeletor.");
				}

				loadTocFiles();
			}

			loadFile(fileName, mainTable_);
			callFunction("OnCreate");
			loadAndExecuteLuaFile(DEFAULT_PROMPTS_FILE_STRING, "prompts.lua");
		}
		else
		{
			throw new Exception("Generator not found!");
		}
	}

	void processInput()
	{
		CollectedValues values = collectValues();

		foreach(key, value; values)
		{
			state_[key] = value.value;
		}

		callFunction("OnProcessInput", values);
	}

	void disableProjectDir()
	{
		disableProjectDir_ = true;
	}

	bool isProjectDirDisabled() const pure @safe
	{
		return disableProjectDir_;
	}

private:
	void loadDefaultModules()
	{
		doFile(buildNormalizedPath(paths_.getModuleDir(), "resty", "template.lua"));
		doFile(buildNormalizedPath(paths_.getModuleDir(), "globals.lua"));
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
			loadFile(buildNormalizedPath(paths_.getGeneratorDir(), file), mainTable_);
		}
	}

	void setupAPIFunctions()
	{
		registerFunction("GetVersion", &getAPIVersion);
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

		registerFunction("Path", "GetBaseGeneratorDir", &paths_.getBaseGeneratorDir);
		registerFunction("Path", "GetGeneratorDirFor", &paths_.getGeneratorDirFor);
		registerFunction("Path", "GetGeneratorDir", &paths_.getGeneratorDir);
		registerFunction("Path", "GetGeneratorLanguageDir", &paths_.getGeneratorLanguageDir);
		registerFunction("Path", "GetOutputDir", &paths_.getOutputDir);
		registerFunction("Path", "GetGeneratorModulesDir", &paths_.getGeneratorModulesDir);
		registerFunction("Path", "GetModuleDir", &paths_.getModuleDir);
		registerFunction("Path", "GetTemplatesDir", &paths_.getTemplatesDir);
		registerFunction("Path", "GetGeneratorTemplatesDir", &paths_.getGeneratorTemplatesDir);
		registerFunction("Path", "Normalize", &paths_.getNormalizedPath);
		registerFunction("Path", "CreateDirInGeneratorDir", &paths_.createDirInGeneratorDir);
		registerFunction("Path", "CreateDirInGeneratorLanguageDir", &paths_.createDirInGeneratorLanguageDir);
		registerFunction("Path", "CreateDirInOutputDir", &paths_.createDirInOutputDir);
		registerFunction("Path", "RemoveDirFromOutputDir", &paths_.removeDirFromOutputDir);
		registerFunction("Path", "DirExists", &paths_.dirExists);
		registerFunction("Path", "OutputDirExists", &paths_.outputDirExists);

		registerFunction("DisableProjectDir", &disableProjectDir);
		registerFunction("IsProjectDirDisabled", &isProjectDirDisabled);

		registerFunction("Downloader", "GetTextFile", &getTextFile);
	}

	void setupPackagePaths()
	{
		immutable string baseModulePath = buildNormalizedPath(paths_.getInstallDir(), "modules");
		immutable string genModulePath = buildNormalizedPath(paths_.getGeneratorDirFor(language_, generatorName_), "modules");

		registerPackagePaths(baseModulePath, genModulePath);
	}

private:
	string language_;
	string generatorName_;
	bool generatorLoaded_;
	bool disableProjectDir_;
	TocParser toc_;
	LuaTable mainTable_;
	ApplicationPaths paths_;
}
