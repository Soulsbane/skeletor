function OnCreate()
end

function OnProcessInput(values)
	--[[print("Called d.raijin generator: ", _G.Author)
	print("Called d.raijin generator again without _G: ", Author)
	print("_G.Year is ", _G.Year)

	for k, v in pairs(values) do
		print(k, v)
	end]]
--	local view = TemplateParser.compile(Path.GetGeneratorTemplatesDir() .. "/main.tpl")
--	local output = view({ Author = Author})
--	print(output)
	local view = TemplateParser.new(Path.GetGeneratorTemplatesDir() .. "/main.tpl")
	view.Author = Author
	view:render()
end

function OnDestroy()
end
