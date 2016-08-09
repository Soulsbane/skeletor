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
	"helpers.lua",
	"ansicolors.lua"
];

void extractGenerators()
{
	debug
	{}
	else
	{
		extractImportFiles!generatorFilesList(getBaseGeneratorDir());
		extractImportFiles!moduleFilesList(getModuleDir());
	}
}
