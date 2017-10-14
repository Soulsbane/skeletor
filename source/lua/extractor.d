module lua.extractor;

import std.stdio;
import std.path;
import std.file: exists, mkdirRecurse;
import std.algorithm;
import std.array;
import std.typetuple;

import lua.api.path;
import dfileutils.extractor;

enum generatorFilesList =
[
	"d/raijin/raijin.lua",
	"d/raijin/templates/raijin-app.d",
	"d/raijin/templates/raijin-dub.sdl",
	"d/raijin/templates/raijin-gitignore",

	"d/lib/lib.lua",
	"d/lib/templates/d.lib.default-lib.d",
	"d/lib/templates/d.lib.dub.sdl",
	"d/lib/templates/d.lib.gitignore",

	"d/app/app.lua",
	"d/app/templates/d.app.app.d",
	"d/app/templates/d.app.dub.sdl",
	"d/app/templates/d.app.gitignore",

	"wow/simplecore/templates/addon.lua",
	"wow/simplecore/templates/template.toc",
	"wow/simplecore/simplecore.lua",

	"tests/test1/test1.lua",
	"tests/test1/templates/main.tpl",
	"tests/test2/test2.lua",
	"tests/test2/test2.toc",
	"tests/test2/utils.lua",
	"tests/test3/test3.lua"
];

enum moduleFilesList =
[
	"resty/template.lua",
	"helpers.lua",
	"ansicolors.lua",
	"globals.lua"
];

void extractGenerators()
{
	debug
	{}
	else
	{
		ApplicationPaths paths;

		extractImportFiles!generatorFilesList(paths.getBaseGeneratorDir());
		extractImportFiles!moduleFilesList(paths.getModuleDir());
	}
}
