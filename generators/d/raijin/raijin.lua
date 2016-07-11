function OnCreate()
	IO.UserInputPrompt("ProjectName", "Project Name(Used as directory name also): ", "foobar")
end

function OnProcessInput(values)
	Path.CreateDirInOutputDir(ProjectName, "source")

	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "dub.sdl"), "raijin-dub.sdl")
	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "source", "app.d"), "raijin-app.d")
	Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, ".gitignore"), "raijin-gitignore")
end

function OnDestroy()
	print(ProjectName .. " was successfully created!")
end
