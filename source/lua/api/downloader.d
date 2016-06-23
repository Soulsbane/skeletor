/**
	Various functions for downloading files.
*/
module lua.api.downloader;

import std.stdio;
import std.conv;
import std.string;
import std.exception;
import requests;

string getTextFile(const string url)
{
	return getContent(url).to!string.ifThrown!ConnectError("");
}
