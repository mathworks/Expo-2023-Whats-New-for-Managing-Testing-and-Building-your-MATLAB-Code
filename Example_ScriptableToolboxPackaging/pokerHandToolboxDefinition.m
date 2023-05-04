function opts = pokerHandToolboxDefinition()

% Get project object
proj = matlab.project.rootProject();

% Create ToolboxOptions object
toolboxFolder = fullfile(proj.RootFolder,"PokerHandsToolbox");
identifier = "1ddfb497-6c7f-41a1-a9d9-a2eab46eb945";
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder,identifier);

% Customize your toolbox
opts.ToolboxName = "Poker Hands Toolbox";
opts.Summary = "Create poker hands using MATLAB!";
opts.Description = "Provides tools to create and compare poker hands.";
opts.AuthorName = "Adam Sifounakis";
opts.ToolboxVersion = "1.1.0"; 
opts.MinimumMatlabRelease = "R2019a";
opts.MaximumMatlabRelease = "";

% Set output file name
toolboxNameNoSpaces = erase(opts.ToolboxName," ");
tbxFileName = toolboxNameNoSpaces + "_" + opts.ToolboxVersion + ".mltbx";
opts.OutputFile = fullfile(proj.RootFolder,"releases",tbxFileName);

end

