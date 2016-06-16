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

void main(string[] arguments)
{
	extractGenerators();

	auto args = new CommandLineArgs;

	debug
	{
		args.addCommand("language", "tests", "The name of language to generate a project for.");
		args.addCommand("generator", "test1", "The name of the generator to use.");
	}
	else
	{
		args.addCommand("language", "d", "The name of language to generate a project for.");
		args.addCommand("generator", "raijin", "The name of the generator to use.");
	}

	args.process(arguments);

	_Config["language"] = args.asString("language");
	_Config["generator"] = args.asString("generator");
	startGenerator(args.asString("language"), args.asString("generator"));
	_Config.save();

	/*SafeIndexArgs args = SafeIndexArgs(arguments);
	immutable string command = args.get(1, "create");

	switch(command)
	{
		case "create":
			startGenerator(args.get(2, "d"), args.get(3, "raijin"));
			break;
		default:
	}*/
}
