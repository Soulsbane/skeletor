module lua.extractor;

import std.stdio;
import std.path;
import std.file: exists, mkdirRecurse;
import std.algorithm;
import std.array;
import std.typetuple;

import raijin.utils;
import lua.api.path;

enum fileNames =
[
	"d/raijin/raijin.lua"
];

// Really cool trick learned from reggae* source code. D really is awesome!
// * https://github.com/atilaneves/reggae/blob/master/src/reggae/reggae.d
private string filesTupleString() @safe pure nothrow
{
	return "TypeTuple!(" ~ fileNames.map!(a => `"` ~ a ~ `"`).join(",") ~ ")";
}

template FileNames()
{
	mixin("alias FileNames = " ~ filesTupleString ~ ";");
}

void extractGenerators()
{
	debug
	{}
	else
	{
		foreach(name; FileNames!())
		{
			immutable string filePath = dirName(buildNormalizedPath(getBaseGeneratorDir(), name));
			immutable string pathWithFileName = buildNormalizedPath(getBaseGeneratorDir(), name);

			ensurePathExists(filePath);
			ensureFileExists(pathWithFileName, import(name));
		}
	}
}
