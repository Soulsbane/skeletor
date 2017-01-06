function OnCreate()
	DisableProjectDir() --We don't need a project directory created since we are creating a new generator.
	UserInput.DisablePrompt("ProjectName")
end

function OnProcessInput(values)
	local language = UserInput.Prompt("ProgrammingLanguage", "Name of the programming language?", "d");
	local name = UserInput.Prompt("GeneratorName", "The name of your generator?", "foobar");
	Path.CreateDirInGeneratorDir(language, name)
end
