function OnCreate()
end

function OnProcessInput(values)
	--[[print("Called d.raijin generator: ", _G.Author)
	print("Called d.raijin generator again without _G: ", Author)
	print("_G.Year is ", _G.Year)

	for k, v in pairs(values) do
		print(k, v)
	end]]
	print(Path.Normalize("this", "is", "a", "test"))
	print(Helpers.ParseTemplate("main.tpl"))
	
	IO.CreateOutputFile("testfiles/test.abc", "hello world")
end

function OnDestroy()
end
