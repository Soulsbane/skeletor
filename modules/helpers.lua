local Helpers = Helpers
local UserInput = UserInput

TemplateParser = require "resty.template"
AnsiColors = require "ansicolors"

--Override resty.templates escape method since we don't need string escaping.
local function Escape(s, c)
	return s
end

TemplateParser.escape = Escape

function Helpers.ParseTemplate(fileName)
	local func = TemplateParser.compile(Path.Normalize(Path.GetGeneratorTemplatesDir(), fileName))
	local str = func(_G) --Might be better to put their own table

	return str
end

function Helpers.ParseAndCreateOutputFile(outputFileName, templateName)
	local data = Helpers.ParseTemplate(templateName)
	IO.CreateOutputFile(outputFileName, data)
end

function Helpers.ParseAndCreateGeneratorFile(language, generatorName, outputFileName, templateName)
	local data = Helpers.ParseTemplate(templateName)
	IO.CreateGeneratorFile(language, generatorName, outputFileName, data)
end

function Helpers.DownloadAndCreateTextFile(url, outputFileName)
	local text = Downloader.GetTextFile(url)
	IO.CreateOutputFile(outputFileName, text)
end

function Helpers.PrintColor(...)
	print(AnsiColors(...))
end

function UserInput.Prompt(globalVarName, msg, defaultValue)
	local defaultValue = defaultValue or ""
	UserInput.PromptWithDefault(globalVarName, msg, defaultValue)
end

return Helpers
