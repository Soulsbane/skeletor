/**
	Various functions for downloading files.
*/
module lua.api.downloader;

import std.stdio;
import std.exception;
import std.conv;
import std.socket;
import std.string;
import std.exception;
import std.net.curl;

string getTextFile(const string url)
{
	return get(url).idup.ifThrown!CurlException("");
}
