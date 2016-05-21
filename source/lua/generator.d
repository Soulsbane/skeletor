module lua.generator;

import luad.all;

struct LuaGenerator
{
	this(const string language, const string generatorName)
	{
		language_ = language;
		generatorName_ = generatorName;
		
		lua_ = new LuaState;
		lua_.openLibs();
		lua_.setPanicHandler(&panic);
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio : writeln;
		writeln("Error in generator code!\n", error, "\n");
	}

private:
	LuaState lua_;
	string language_;
	string generatorName_;
}
