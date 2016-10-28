function OnProcessInput(values)
	Helpers.DownloadAndCreateTextFile("https://raw.githubusercontent.com/Soulsbane/SimpleCore/master/SimpleCore.lua", "SimpleCore.lua")
	Helpers.ParseAndCreateOutputFile(UserInput.GetValueFor("ProjectName", "Addon") .. ".toc", "template.toc")
	Helpers.ParseAndCreateOutputFile(UserInput.GetValueFor("ProjectName", "Addon") .. ".lua", "addon.lua")
end