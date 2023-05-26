function opts = pokerHandsToolboxDefinition()
%POKERHANDTOOLBOXDEFINITION Returns a ToolboxOptions object for the Poker Hands Toolbox
%
%  opts = pokerHandsToolboxDefinition() returns a ToolboxOptions object that
%  can be used to create a MATLAB Toolbox for the Poker Hands Toolbox.
%
%  Example:
%     opts = pokerHandsToolboxDefinition();
%     matlab.addons.toolbox.packageToolbox(opts);
%
%  See also matlab.project.rootProject,
%  matlab.addons.toolbox.ToolboxOptions,
%  matlab.addons.toolbox.packageToolbox

proj = matlab.project.rootProject();

toolboxFolder = fullfile(proj.RootFolder,"toolbox");
identifier = "1ddfb497-6c7f-41a1-a9d9-a2eab46eb945"; % Please modify this identifier for your toolbox
opts = matlab.addons.toolbox.ToolboxOptions(toolboxFolder,identifier);

opts.ToolboxName = "Poker Hands Toolbox";
opts.Summary = "Create poker hands using MATLAB!";
opts.Description = "Provides tools to create and compare poker hands.";
opts.AuthorName = "Adam Sifounakis";
opts.ToolboxVersion = "1.0.1";
opts.MinimumMatlabRelease = "R2019a";
opts.MaximumMatlabRelease = "";

toolboxNameNoSpaces = erase(opts.ToolboxName," ");
tbxFileName = toolboxNameNoSpaces + "_" + opts.ToolboxVersion + ".mltbx";
opts.OutputFile = fullfile(proj.RootFolder,"releases",tbxFileName);

end