import std.stdio : writeln;
import std.file;
import std.algorithm;
import std.array;
import std.string;
import std.range;
import std.path;

import raijin;

import config;
import inputcollector;
import lua.generator;
import lua.api.path;
import lua.extractor;
import luaaddon.tocparser;

bool createProjectDir()
{
	if(inputcollector.hasValueFor("ProjectName"))
	{
		immutable string path = buildNormalizedPath(getcwd(), getValueFor("ProjectName"));

		if(path.exists)
		{
			return false;
		}

		return ensurePathExists(path);
	}

	return false;
}

bool startGenerator(const string language, const string generatorName)
{
	auto generator = MakeLuaGenerator();

	try
	{
		generator.create(language, generatorName);

		immutable bool created = createProjectDir();

		if(created)
		{
			generator.processInput();
			generator.destroy();

			return true;
		}
		else
		{
			writeln("Error: project directory already exists!");
			return false;
		}
	}
	catch(Exception ex)
	{
		writeln(ex.msg);
		return false;
	}
}

auto getDirList(const string name, SpanMode mode)
{
	auto dirs = dirEntries(name, mode)
		.filter!(a => a.isDir && !a.name.startsWith("."))
		.array
		.retro;

	return dirs;
}

@CommandHelp("Creates a new project.", ["The programming language in which to generate a project.",
	"The name of the generator to use to generate a project."])
void create(string language, string generator)
{
	immutable bool succeeded = startGenerator(language, generator);

	if(succeeded)
	{
		_Config.set("Config", "generator", generator);
		_Config.set("Config", "language", language);

		_Config.save();
	}
}

@CommandHelp("Creates a new project using the <language>.<generator> format.",
	["The programming language and generator separated by a dot: <language>.<generator>"])
void create(string languageAndgenerator)
{
	auto parts = languageAndgenerator.split(".");

	if(parts.length == 2)
	{
		create(parts[0], parts[1]);
	}
	else
	{
		create("", "");// split contained less than 2 args. Send empty strings so an error no generator found is thrown.
	}

}

@CommandHelp("Creates a new project using the default language and generator found in config.lua.")
void create()
{
	create(_Config.get("Config", "language", "d"), _Config.get("Config", "generator", "raijin"));
}

@CommandHelp("Lists all the available generators")
void list(string language = "all")
{
	writeln("The following generators are available:");
	writeln;

	size_t count;

	foreach(name; getDirList(getBaseGeneratorDir(), SpanMode.shallow))
	{
		if(language == "all" || name.baseName == language)
		{
			++count;
			writeln(name.baseName);

			foreach(generatorName; getDirList(buildNormalizedPath(getBaseGeneratorDir(), name.baseName), SpanMode.shallow))
			{
				TocParser parser;
				string description = "No description available.";
				immutable string baseName = generatorName.baseName;
				immutable string tocFileName = buildNormalizedPath(generatorName, baseName ~ ".toc");

				if(tocFileName.exists)
				{
					parser.loadFile(tocFileName);
					description = parser.getValue("Description");
				}

				writeln(" └─", baseName, " - ", description);
			}

			writeln;
		}
	}

	if(count == 0)
	{
		writeln("Could not find any generators using language: ", language);
	}
}

@CommandHelp("Provides more information about a generator.")
void info(string language, string name)
{
	TocParser parser;
	immutable string tocFileName = buildNormalizedPath(getGeneratorDirFor(language, name), name ~ ".toc");

	writeln("Showing information for generator ", name, ":");
	writeln;

	if(tocFileName.exists)
	{
		parser.loadFile(tocFileName);

		writeln("Author - ", parser.getValue("Author"));
		writeln("Description - ", parser.getValue("Description"));
	}
	else
	{
		writeln("No information could be found!");
	}
}

@CommandHelp("Provides more information about a generator.")
void info(string languageAndGenerator)
{
	auto parts = languageAndGenerator.split(".");

	if(parts.length == 2)
	{
		info(parts[0], parts[1]);
	}
	else
	{
		info("", "");// split contained less than 2 args. Send empty strings so an error no generator found is thrown.
	}


}
void main(string[] arguments)
{
	extractGenerators();
	mixin Commander;

	Commander cmd;
	cmd.process(arguments);
}
