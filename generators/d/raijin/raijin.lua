local Success

function OnCreate()
	UserInput.Prompt("ProjectName", "Project Name(Used as directory name also): ", "foobar")
end

function OnProcessInput(values)
	if Path.OutputDirExists(ProjectName) then
		print("Failed to create directory. " .. ProjectName .. " already exists")
		Success = false
	else
		Path.CreateDirInOutputDir(ProjectName, "source")

		Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "dub.sdl"), "raijin-dub.sdl")
		Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, "source", "app.d"), "raijin-app.d")
		Helpers.ParseAndCreateOutputFile(Path.Normalize(ProjectName, ".gitignore"), "raijin-gitignore")

		Success = true
	end
end

function OnDestroy()
	if Success then
		print(ProjectName .. " was successfully created!")
	end
end
