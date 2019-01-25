function OnFinishedInput()
	Helpers.ParseAndCreateOutputFile("Cargo.toml", "rust.cli.Cargo.toml")
	Helpers.ParseAndCreateOutputFile(Path.Normalize("src", "main.rs"), "rust.cli.main.rs")
end
