function OnCreate()
	DisableProjectDir() --We don't need a project directory created since we are creating a new generator.
	UserInput.DisablePrompt("ProjectName") -- Should really be in DisableProjectDir
end

function OnProcessInput()
	UserInput.Prompt("ProgrammingLanguage", "Name of the programming language?", "d")
	UserInput.Prompt("GeneratorName", "The name of your generator?", "foobar")
end

function OnFinishedInput()
	local language = UserInput.GetValueFor("ProgrammingLanguage")
	local name = UserInput.GetValueFor("GeneratorName")

	if UserInput.HasValueFor("ProgrammingLanguage") and UserInput.HasValueFor("GeneratorName") then
		Helpers.ParseAndCreateGeneratorFile(language, name, name .. ".toc", "template.toc")
		Helpers.ParseAndCreateGeneratorFile(language, name, name .. ".lua", "template.lua")
	end
end
