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

bool createProjectDir()
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
				return true;
			}

			writeln("Failed to create directory: ", projectName);
			return false;
		}
		else
		{
			writeln("ERROR: project name, ", projectName, " already exists!");
			return false;
		}
	}

	return false;
}

bool startGenerator(const string language, const string generatorName)
{
	LuaGenerator generator = new LuaGenerator;
	immutable bool succeeded = generator.create(language, generatorName);

	if(succeeded)
	{
		immutable bool created = createProjectDir();

		if(created)
		{
			generator.processInput();
		}
	}
	else
	{
		writeln("Generator not found!");
	}

	generator.destroy();

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
		_Config["language"] = language;
		_Config["generator"] = generator;

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
			writeln("  ", generatorName.baseName);
		}

		writeln;
	}
}

void main(string[] arguments)
{
	extractGenerators();
	mixin Commander;

	Commander cmd;
	cmd.process(arguments);
}
