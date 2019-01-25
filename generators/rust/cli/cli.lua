function OnCreate()
	--This is where initializing global vars etc should go.
end

function OnProcessInput()
	--This is where calls to UserInput.Prompt calls should go.
end

function OnFinishedInput()
	Helpers.ParseAndCreateOutputFile("Cargo.toml", "rust.cli.Cargo.toml")
	Helpers.ParseAndCreateOutputFile(Path.Normalize("src", "main.rs"), "rust.cli.main.rs")
end

function OnDestroy()
	--Cleaning up any temporary files etc should go here.
end
