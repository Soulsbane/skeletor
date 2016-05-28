import std.stdio : writeln;

import raijin;

import inputcollector;
import lua.generator;
import lua.api.path;

void main(string[] arguments)
{
	CollectedValues values = collectValues();
	LuaGenerator generator = LuaGenerator("d", "raijin");
	immutable bool succeeded = generator.create(values);

	if(!succeeded)
	{
		writeln("Generator not found!");
	}
}
