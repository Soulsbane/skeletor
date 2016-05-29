function OnCreate()
	local year = Input.UserInputPrompt("Year", "Year: ", "1959")
	print("Year is ", year)
end

function OnProcessInput(values)
	print("Called d.raijin generator: ", _G.Author)
	print("_G.Year is ", _G.Year)

	for k, v in pairs(values) do
		print(k, v)
	end
end

function OnDestroy()
end
