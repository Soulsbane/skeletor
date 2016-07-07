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

void onCreate(const string commandName, string[] args...)
{
	immutable string language = args[0];
	immutable string generator = args[1];
	immutable bool succeeded = startGenerator(language, generator);

	if(succeeded)
	{
		extractGenerators();

		_Config["language"] = language;
		_Config["generator"] = generator;

		_Config.save();
	}
}

void main(string[] arguments)
{
	Commander commands;

	commands.addCommand("create", "2", &onCreate);
	commands.process(arguments);
}
