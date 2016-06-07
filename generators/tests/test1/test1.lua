function OnCreate()
end

function OnProcessInput(values)
	--[[print("Called d.raijin generator: ", _G.Author)
	print("Called d.raijin generator again without _G: ", Author)
	print("_G.Year is ", _G.Year)

	for k, v in pairs(values) do
		print(k, v)
	end]]
	print(Helpers.ParseTemplate("main.tpl"))
end

function OnDestroy()
end
