local Success

function OnCreate()
end

function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	Helpers.ParseAndCreateOutputFile("dub.sdl", "raijin-dub.sdl")
	Helpers.ParseAndCreateOutputFile(Path.Normalize("source", "app.d"), "raijin-app.d")
	Helpers.ParseAndCreateOutputFile(".gitignore", "raijin-gitignore")
end

function OnDestroy()
end
