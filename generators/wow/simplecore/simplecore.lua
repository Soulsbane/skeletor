function OnProcessInput(values)
	local text = Downloader.GetTextFile("https://raw.githubusercontent.com/Soulsbane/SimpleCore/master/SimpleCore.lua")
	IO.CreateOutputFile("SimpleCore.lua", text)
end