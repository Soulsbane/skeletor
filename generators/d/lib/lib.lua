function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	Helpers.ParseAndCreateOutputFile("dub.sdl", "dub.sdl")
	Helpers.ParseAndCreateOutputFile(".gitignore", "gitignore")
end
