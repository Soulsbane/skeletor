module lua.api;

enum API_VERSION = 100;

size_t getAPIVersion()
{
	return API_VERSION;
}

public
{
	import lua.api.path;
	import lua.api.filereader;
	import lua.api.filewriter;
	import lua.api.fileutils;
	import lua.api.downloader;
}