function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")
	local projectName = UserInput.GetValueFor("ProjectName")

	local createSubDir =
		UserInput.ConfirmationPrompt("Create additional directory inside source directory using Project Name(y/n)?")
	local createLibFile = UserInput.ConfirmationPrompt("Also create a default library file(y/n)?")

	if createSubDir then
		Path.CreateDirInOutputDir(Path.Normalize("source", projectName))
	end

	if(createLibFile) then
		local fileName = Path.Normalize("source", projectName, projectName .. ".d")

		Helpers.ParseAndCreateOutputFile(fileName, "d.lib.default-lib.d")
		Helpers.ParseAndCreateOutputFile(Path.Normalize("source", projectName, "package.d"), "d.lib.package.d")

	end

	Helpers.ParseAndCreateOutputFile("dub.sdl", "d.lib.dub.sdl")
	Helpers.ParseAndCreateOutputFile(".gitignore", "d.lib.gitignore")
end
