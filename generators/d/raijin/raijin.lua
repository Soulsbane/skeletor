function OnCreate()
	IO.UserInputPrompt("ProjectName", "Project Name(Used as directory name also): ", "foobar")
end

function OnProcessInput(values)
	Path.CreateDirInOutputDir(ProjectName, "source")

	local dubData = Helpers.ParseTemplate("raijin-dub.sdl")
	IO.CreateOutputFile(ProjectName .. "/dub.sdl", dubData)

	local appData = Helpers.ParseTemplate("raijin-app.d")
	IO.CreateOutputFile(ProjectName .. "/source/app.d", appData)
end

function OnDestroy()
end
