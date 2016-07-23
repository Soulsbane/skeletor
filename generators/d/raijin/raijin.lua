local Success

function OnCreate()
end

function OnProcessInput(values)
	Path.CreateDirInOutputDir(ProjectName, "source")

	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "dub.sdl"), "raijin-dub.sdl")
	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "source", "app.d"), "raijin-app.d")
	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, ".gitignore"), "raijin-gitignore")
end

function OnDestroy()
end
