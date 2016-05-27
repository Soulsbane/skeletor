import std.stdio;
import raijin;

import lua.generator;
import lua.api.path;

void main(string[] arguments)
{
	LuaGenerator generator = LuaGenerator("d", "raijin");
	immutable bool succeeded = generator.create();

	if(!succeeded)
	{
		writeln("Generator not found!");
	}
}
