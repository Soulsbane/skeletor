module lua.luaaddon;

import luad.all;

struct LuaAddon
{
	void setupEnvironment()
	{
		state_ = new LuaState;
		state_.openLibs();
		state_.setPanicHandler(&panic);
	}

	static void panic(LuaState lua, in char[] error)
	{
		import std.stdio : writeln;
		writeln("Error in generator code!\n", error, "\n");
	}

	bool callFunction(T...)(const string name, T args)
	{
		if(hasFunction(name))
		{
			state_.get!LuaFunction(name)(args);
			return true;
		}

		return false;
	}

	bool hasFunction(const string name)
	{
		return state_[name].isNil ? false : true;
	}

	LuaState state_;
	alias state_ this;
}
