import std.stdio : writeln;

import raijin;

import inputcollector;
import lua.generator;
import lua.api.path;

class Arguments : CommandLineArgs
{
	override void onValidArgs()
	{
		validArgsPassed_ = true;
	}

	bool hasValidArgs() @property const
	{
		return validArgsPassed_;
	}

private:
	bool validArgsPassed_;
}

void main(string[] arguments)
{
	auto args = new Arguments;

	args.addCommand("language", "d", "The name of language to generate a project for.");
	args.addCommand("generator", "raijin", "The name of the generator to use.");
	args.process(arguments);

	if(args.hasValidArgs)
	{
		CollectedValues values = collectValues();
		LuaGenerator generator = LuaGenerator("d", "raijin");
		immutable bool succeeded = generator.create(values);

		if(!succeeded)
		{
			writeln("Generator not found!");
		}
	}
}
