import std.stdio : writeln;

import raijin;

import inputcollector;
import lua.generator;
import lua.api.path;
import lua.extractor;

void main(string[] arguments)
{
	auto args = new CommandLineArgs;

	args.addCommand("language", "d", "The name of language to generate a project for.");
	args.addCommand("generator", "raijin", "The name of the generator to use.");
	args.process(arguments);

	extractGenerators();
	LuaGenerator generator = LuaGenerator(args.asString("language"), args.asString("generator"));
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
