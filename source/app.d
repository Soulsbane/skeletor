import std.stdio : writeln;

import raijin;

import config;
import inputcollector;
import lua.generator;
import lua.api.path;
import lua.extractor;

bool startGenerator(const string language, const string generatorName)
{
	LuaGenerator generator;
	immutable bool succeeded = generator.create(language, generatorName);

	if(succeeded)
	{
		generator.processInput();
	}
	else
	{
		writeln("Generator not found!");
	}

	return succeeded;
}

@CommandHelp("Creates a new project.", ["Name of the programming language the project will use.",
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

void main(string[] arguments)
{
	extractGenerators();
	mixin Commander;
	
	Commander cmd;
	cmd.process(arguments);
}
