/**
	API functions for launching a child process.
*/
module lua.api.process;
import std.conv;
import std.array;

// FIXME: return the value that processwait's function returns.
// luad gives a compilation issue if return type is auto.
void waitForApplication(string args)
{
	import processwait;
	processwait.waitForApplication(args);
}
