/**
	Provides various path related API functions for use with Lua.
*/
module lua.api.path;

import std.file : exists, getcwd, thisExePath;
import std.path : dirName, buildNormalizedPath;

import raijin.utils.path;
import raijin.utils.file;
import config;
import inputcollector;

struct ApplicationPaths
{
public:

	void setLanguageAndGeneratorName(const string language, const string name)
	{
		language_ = language;
		generatorName_ = name;
	}

	string getInstallDir()
	{
		return dirName(thisExePath());
	}

	string getBaseGeneratorDir()
	{
		debug
		{
			return buildNormalizedPath(getInstallDir(), "generators");
		}
		else
		{
			return _Config.getConfigDir("generators");
		}
	}

	string getGeneratorLanguageDir(const string language = string.init)
	{
		debug
		{
			return buildNormalizedPath(getInstallDir(), "generators", language);
		}
		else
		{
			return _Config.getConfigDir("generators", language);
		}
	}

	string getGeneratorDirFor(const string language = string.init, const string generatorName = string.init)
	{
		debug
		{
			return buildNormalizedPath(getInstallDir(), "generators", language, generatorName);
		}
		else
		{
			return _Config.getConfigDir("generators", language, generatorName);
		}
	}

	string getOutputDir()
	{
		return buildNormalizedPath(getcwd(), getValueFor("ProjectName"));
	}

	string getModuleDir()
	{
		debug
		{
			return buildNormalizedPath(getInstallDir(), "modules");
		}
		else
		{
			return _Config.getConfigDir("modules");
		}
	}

	string getTemplatesDir()
	{
		debug
		{
			return buildNormalizedPath(getInstallDir(), "templates");
		}
		else
		{
			return _Config.getConfigDir("templates");
		}
	}

	string getNormalizedPath(const(char)[][] params...)
	{
		return buildNormalizedPath(params);
	}

	bool createDirInGeneratorDir(const(char)[][] params...)
	{
		immutable string path = buildNormalizedPath(params);
		return ensurePathExists(buildNormalizedPath(getBaseGeneratorDir(), path));
	}

	bool createDirInOutputDir(const(char)[][] params...)
	{
		immutable string path = buildNormalizedPath(params);
		return ensurePathExists(buildNormalizedPath(getOutputDir(), path));
	}

	bool removeDirFromOutputDir(const string dir)
	{
		return removePathIfExists(getOutputDir(), dir);
	}

	bool dirExists(const string dir) const
	{
		return dir.exists;
	}

	bool outputDirExists(const string dir)
	{
		string file = buildNormalizedPath(getOutputDir(), dir);
		return file.exists;
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
}
