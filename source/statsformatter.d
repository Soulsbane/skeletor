module statsformatter;

import std.stdio, std.algorithm, std.conv, std.range;

import colored;
import asciitable;

string formatNumber(T)(T number)
{
	import std.regex : regex, replaceAll;

	auto re = regex(`(?<=\d)(?=(\d\d\d)+\b)`,"g");

	static if(is(typeof(T) == string))
	{
		return number.replaceAll(re, ",");
	}
	else
	{
		return number.to!string.replaceAll(re, ",");
	}
}

string surround(const string value)
{
	import std.format : format;
	return value.format!" %s ";
}

class CustomAsciiParts : Parts
{
	this()
	{
		super("-", "|", "+", "+", "+", "+", "+", "+", "+", "+", "+", "-", "+", "+", "+");
	}
}

class CustomAsciiTable : AsciiTable
{
	this(size_t numColumns)
	{
		super(numColumns);
	}

	override Formatter format()
	{
		return Formatter(this);
	}
}

class StatsFormatter
{
	CustomAsciiTable table_;

	this(size_t numColumns)
	{
		table_ = new CustomAsciiTable(numColumns);
	}

	void writeHeader(T...)(T args)
	{
		auto header = table_.header;

		static foreach(arg; args)
		{
			header.add(arg.surround);
		}
	}

	void addBlankRow()
	{
		addRow(" "," "," "," "," "," ");
	}

	void addRow(T...)(T args)
	{
		auto row = table_.row;

		static foreach(arg; args)
		{
			row.add(arg.formatNumber.surround);
		}
	}

	void render()
	{
		auto formattedTable = table_
		.format
		.parts(new CustomAsciiParts)
		.borders(true)
		.separators(true)
		.to!string
		.lightBlue;

		writeln(formattedTable);
	}
}
