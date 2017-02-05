function OnFinishedInput(values)
	Path.CreateDirInOutputDir("source")

	local createSubDir =
		UserInput.ConfirmationPrompt("Create additional directory inside source directory using Project Name(y/n?")

	if createSubDir then
		Path.CreateDirInOutputDir(Path.Normalize("source", UserInput.GetValueFor("ProjectName")))
	end

	Helpers.ParseAndCreateOutputFile("dub.sdl", "d.lib.dub.sdl")
	Helpers.ParseAndCreateOutputFile(".gitignore", "d.lib.gitignore")
end
