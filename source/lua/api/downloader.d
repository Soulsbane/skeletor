/**
	Various functions for downloading files.
*/
module lua.api.downloader;

import std.stdio;
import std.conv;
import std.string;
import std.exception;
import arsd.http2;

string getTextFile(const string url)
{
	return getText(url);
}
