module lua.extractor;

import std.stdio;
import std.path;
import std.file: exists, mkdirRecurse;
import std.algorithm;
import std.array;
import std.typetuple;

import raijin.utils;
import lua.api.path;

enum generatorFilesList =
[
	"d/raijin/raijin.lua",
	"d/raijin/templates/raijin-app.d",
	"d/raijin/templates/raijin-dub.sdl",
	"d/raijin/templates/raijin-gitignore",
	"tests/test1/test1.lua",
	"tests/test1/templates/main.tpl",
];

enum moduleFilesList =
[
	"resty/template.lua",
	"helpers.lua"
];

// Really cool trick learned from reggae* source code. D really is awesome!
// * https://github.com/atilaneves/reggae/blob/master/src/reggae/reggae.d
private string generatorFilesTupleString() @safe pure nothrow
{
	return "TypeTuple!(" ~ generatorFilesList.map!(a => `"` ~ a ~ `"`).join(",") ~ ")";
}

private string generatorModuleFilesTupleString() @safe pure nothrow
{
	return "TypeTuple!(" ~ moduleFilesList.map!(a => `"` ~ a ~ `"`).join(",") ~ ")";
}

template GeneratorFileNames()
{
	mixin("alias GeneratorFileNames = " ~ generatorFilesTupleString ~ ";");
}

template ModuleFileNames()
{
	mixin("alias ModuleFileNames = " ~ generatorModuleFilesTupleString ~ ";");
}

void extractGenerators()
{
	debug
	{}
	else
	{
		foreach(name; GeneratorFileNames!())
		{
			immutable string filePath = dirName(buildNormalizedPath(getBaseGeneratorDir(), name));
			immutable string pathWithFileName = buildNormalizedPath(getBaseGeneratorDir(), name);

			ensurePathExists(filePath);
			ensureFileExists(pathWithFileName, import(name));
		}

		foreach(name; ModuleFileNames!())
		{
			immutable string modulesPath = dirName(buildNormalizedPath(getModuleDir(), name));
			immutable string modulesPathWithFileName = buildNormalizedPath(getModuleDir(), name);

			ensurePathExists(modulesPath);
			ensureFileExists(modulesPathWithFileName, import(name));
		}
	}
}
