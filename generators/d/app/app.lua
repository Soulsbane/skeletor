function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	Helpers.ParseAndCreateOutputFile("dub.sdl", "dub.sdl")
	Helpers.ParseAndCreateOutputFile(Path.Normalize("source", "app.d"), "app.d")
	Helpers.ParseAndCreateOutputFile(".gitignore", "gitignore")
end
