import std.stdio;

import dapplicationbase;

struct Options
{
	@GetOptOptions("This is a fake command line argument that is also stored using StructOptions")
	string fake;
}

class {{ProjectName}}Application : Application!Options
{
	this() {}
}

void main(string[] arguments)
{
	auto app = new {{ProjectName}}Application;
	app.create("Raijinsoft", "{{ProjectName}}", arguments);
}
