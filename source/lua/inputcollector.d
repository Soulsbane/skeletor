/**
	Handles the processing of values inputted by the user.
*/
module inputcollector;

import std.typecons;
import std.stdio;
import std.string;

alias CollectedValues = Prompt[string];
private CollectedValues _Values;

struct Prompt
{
	string variableName;
	string value;
	bool enabled;
}

string userInputPrompt(const string globalVarName, const string msg, string defaultValue = string.init)
{
	if(defaultValue == string.init)
	{
		writef("%s: ", msg);
	}
	else
	{
		writef("%s [%s]: ", msg, defaultValue);
	}

	string input = readln();

	if(input == "\x0a") // Only enter was pressed use the default value instead.
	{
		input = defaultValue;
	}

	Prompt prompt;

	prompt.variableName = globalVarName;
	prompt.value = input.strip;
	prompt.enabled = true;

	_Values[globalVarName] = prompt;

	return input.strip;
}

bool hasValueFor(const string key)
{
	if(key in _Values)
	{
		return true;
	}

	return false;
}

string getValueFor(const string key, string defaultValue = string.init)
{
	if(hasValueFor(key))
	{
		return _Values[key].value;
	}

	return defaultValue;
}

void enablePrompt(const string name)
{
	if(hasValueFor(name))
	{
		_Values[name].enabled = true;
	}
}

void disablePrompt(const string name)
{
	if(hasValueFor(name))
	{
		_Values[name].enabled = false;
	}
}

bool isPromptEnabled(const string name)
{
	if(hasValueFor(name))
	{
		return _Values[name].enabled;
	}

	return false;
}

CollectedValues collectValues()
{
	return _Values;
}
