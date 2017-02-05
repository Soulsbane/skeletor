function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	Helpers.ParseAndCreateOutputFile("dub.sdl", "d.app.dub.sdl")
	Helpers.ParseAndCreateOutputFile(Path.Normalize("source", "app.d"), "app.d")
	Helpers.ParseAndCreateOutputFile(".gitignore", "d.app.gitignore")
end
