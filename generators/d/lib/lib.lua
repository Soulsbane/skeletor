function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	Helpers.ParseAndCreateOutputFile("dub.sdl", "d.lib.dub.sdl")
	Helpers.ParseAndCreateOutputFile(".gitignore", "d.lib.gitignore")
end
