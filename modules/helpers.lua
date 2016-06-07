local Helpers = Helpers
TemplateParser = require "resty.template"

function Helpers.ParseTemplate(fileName)
	local func = TemplateParser.compile(Path.GetGeneratorTemplatesDir() .. "/" .. fileName)
	local str = func(_G) --Might be better to put their own table

	return str
end

return Helpers
