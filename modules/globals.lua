--Various functions that are missing from the Lua standard library.
AnsiColors = require "ansicolors"

--INFO: The various write* functions should only be used if you need color in your output.
function writeln(...)
	print(AnsiColors(...))
end

function write(...)
	io.write(AnsiColors(...))
end

function writef(s,...)
	io.write(AnsiColors(s:format(...)))
end

function writefln(s,...)
	io.write(AnsiColors(s:format(...)))
	io.write("\n")
end
