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

@CommandHelp("Creates a new project.")
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
	mixin Commander;
	Commander cmd;
	bool succeeded = cmd.process(arguments);

	if(!succeeded && !arguments.length > 2)
	{
		debug writeln("Invalid option!");
	}
}
