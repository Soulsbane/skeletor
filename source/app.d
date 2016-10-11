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

void createProjectDir()
{
	if(inputcollector.hasValueFor("ProjectName"))
	{
		immutable string projectName = inputcollector.getValueFor("ProjectName");

		if(!outputDirExists(projectName))
		{
			immutable bool created = createDirInOutputDir(projectName);

			if(created)
			{
				writeln(projectName, " was successfully created!");
			}

			writeln("Failed to create directory: ", projectName);
		}
		else
		{
			writeln("ERROR: project name, ", projectName, " already exists!");
		}
	}
}

bool startGenerator(const string language, const string generatorName)
{
	auto generator = MakeLuaGenerator();
	immutable bool succeeded = generator.create(language, generatorName);

	if(succeeded)
	{
		generator.processInput();
		createProjectDir();
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
		writeln("[", name.baseName.capitalize, "]");

		foreach(generatorName; getDirList(buildNormalizedPath(getBaseGeneratorDir(), name.baseName), SpanMode.shallow))
		{
			TocParser parser;
			immutable string tocFileName = buildNormalizedPath(generatorName, generatorName.baseName ~ ".toc");
			string description;
			///TODO: store baseName

			if(tocFileName.exists)
			{
				parser.loadFile(tocFileName);
				description = parser.getValue("Description");
			}

			if(description.length)
			{
				writeln("  ", generatorName.baseName, " - ", description);
			}
			else
			{
				writeln("  ", generatorName.baseName);
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
