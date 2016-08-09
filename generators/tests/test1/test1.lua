function OnCreate()
	print("Downloading...")
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
	local text = Downloader.GetTextFile("https://raw.githubusercontent.com/Soulsbane/skeletor/master/source/default-init.lua")
	print(text)
end

function OnDestroy()
	local answer = UserInput.ConfirmationPrompt("Are you sure you want to quit(y/n)?")
	if answer then
		print("Quitting...", "Now")
	else
		Helpers.PrintColor("%{red}That's too bad quitting anyway!!!")
		Helpers.PrintColor("%{white blink underline}Hahahahah...")
	end
end
