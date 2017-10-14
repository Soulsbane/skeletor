module lua.api.prompts;

import std.stdio;
import std.string;
import std.typecons;
import std.range;
/**
	Pauses the program until the enter key is pressed

	Params:
		msg = The message to display.
*/
void pause(const string msg = "Press enter/return to continue...")
{
	write(msg);
	getchar();
}

/**
	Clears the terminal of all output.
*/
void clear()
{
	version(linux)
	{
		write("\x1B[2J\x1B[H");
	}

	version(windows)
	{
		// call cls
	}
}

/**
	Display a prompt that contains a yes(Y/y) or no instruction.
*/
bool confirmationPrompt(string msg = "Do you wish to continue(y/n): ")
{
	write(msg);
	immutable auto answer = readln();

	if(answer.front == 'Y' || answer.front == 'y')
	{
		return true;
	}

	return false;
}
