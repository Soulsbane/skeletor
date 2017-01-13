function OnProcessInput(values)
	Helpers.DownloadAndCreateTextFile("https://raw.githubusercontent.com/Soulsbane/SimpleCore/master/SimpleCore.lua", "SimpleCore.lua")
	Helpers.ParseAndCreateOutputFile(UserInput.GetValueFor("ProjectName") .. ".toc", "template.toc")
	Helpers.ParseAndCreateOutputFile(UserInput.GetValueFor("ProjectName") .. ".lua", "addon.lua")
end
