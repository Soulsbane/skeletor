import std.stdio : writeln;

import raijin;

import inputcollector;
import lua.generator;
import lua.api.path;

void main(string[] arguments)
{
	auto args = new CommandLineArgs;

	args.addCommand("language", "d", "The name of language to generate a project for.");
	args.addCommand("generator", "raijin", "The name of the generator to use.");
	args.process(arguments);

	CollectedValues values = collectValues();
	LuaGenerator generator = LuaGenerator(args.asString("language"), args.asString("generator"));
	immutable bool succeeded = generator.process(values);

	if(!succeeded)
	{
		writeln("Generator not found!");
	}
}
