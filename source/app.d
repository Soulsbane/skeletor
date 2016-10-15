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
	immutable bool succeeded = generator.create(language, generatorName);

	if(succeeded)
	{
		immutable bool created = createProjectDir();

		if(created)
		{
			generator.processInput();
			generator.destroy();
		}
		else
		{
			writeln("Error: project directory already exists!");
		}
	}
	else
	{
		writeln("Generator not found!");
	}

	return succeeded;
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

@CommandHelp("Lists all the available generators")
void list()
{
	writeln("The following generators are available:");
	writeln;

	foreach(name; getDirList(getBaseGeneratorDir(), SpanMode.shallow))
	{
		writeln(name.baseName.capitalize);

		foreach(generatorName; getDirList(buildNormalizedPath(getBaseGeneratorDir(), name.baseName), SpanMode.shallow))
		{
			TocParser parser;
			immutable string baseName = generatorName.baseName;
			immutable string tocFileName = buildNormalizedPath(generatorName, baseName ~ ".toc");
			string description;

			if(tocFileName.exists)
			{
				parser.loadFile(tocFileName);
				description = parser.getValue("Description");
			}

			if(description.length)
			{
				writeln(" |--", baseName, " - ", description);
			}
			else
			{
				writeln(" |--", baseName);
			}
		}

		writeln;
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

void main(string[] arguments)
{
	extractGenerators();
	mixin Commander;

	Commander cmd;
	cmd.process(arguments);
}
