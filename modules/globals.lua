--Various functions that are missing from the Lua standard library.
function writeln(...)
	print(...)
end

function write(...)
	io.write(...)
end

function writef(s,...)
	io.write(s:format(...))
end

function writefln(s,...)
	io.write(s:format(...))
	io.write("\n")
end
