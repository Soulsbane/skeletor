# Current Status

This program uses the LuaD library which hasn't been updated in years. Due to that Skeletor will no longer compile on a newer D compiler. At this point I'm still deciding whether to switch to Lumars or just plain rewrite it in Go which I'm much more familiar with at this point than D.

## Description

Skeletor is a project generator for programmers written in the [D Programming Language](http://dlang.org/).

## Generators

A generator is a plugin(addon, extension etc) that is used to interface with Skeletor in order to create the specified project.
Generators are written in the [Lua Programming Language](https://www.lua.org/).
