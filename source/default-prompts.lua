UserInput.Prompt("Author", "Author ", "Paul Crane");
UserInput.Prompt("Description", "Description", "Project Description");

--NOTE: Removing this will most like result in an error since ProjectName must be defined.
UserInput.Prompt("ProjectName", "Project Name(Used as directory name as well): ", "foobar")
