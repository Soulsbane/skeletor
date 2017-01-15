module lua.api;

// The version is broken down as follows Major.Minor.Revsion.
// The Major will only be changed in the event that an API was removed.
// The Minor will only be changed in the event that an API was added.
// The Revision will only be changed in the event that an API was modified in how it's called or how it works
// internally if it differs.
// So using 10200 as an example when changed to a string it would be 1.02.00
private enum API_VERSION = 10500;

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
