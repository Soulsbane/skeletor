/**
	API functions for launching a child process.
*/
module lua.api.process;
import std.conv;
import std.array;

int waitForApplication(string args)
{
	import processwait;
	return processwait.waitForApplication(args);
}
