import std.stdio : writeln;

import raijin;

import config;
import inputcollector;
import lua.generator;
import lua.api.path;
import lua.extractor;

void startGenerator(const string language, const string generatorName)
{
	LuaGenerator generator = LuaGenerator(language, generatorName);
	immutable bool succeeded = generator.create();

	if(succeeded)
	{
		generator.processInput();
	}
	else
	{
		writeln("Generator not found!");
	}
}

void onCreate(const string commandName, string[] args...)
{
	immutable string language = args[0];
	immutable string generator = args[1];

	extractGenerators();

	_Config["language"] = language;
	_Config["generator"] = generator;

	startGenerator(language, generator);
	_Config.save();
}

void main(string[] arguments)
{
	Commander commands;

	commands.addCommand("create", "2", &onCreate);
	commands.process(arguments);
}
