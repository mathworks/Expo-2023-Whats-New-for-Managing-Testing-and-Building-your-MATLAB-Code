function plan = buildfile
plan = buildplan(localfunctions);

% Open project if it is not open
if isempty(matlab.project.rootProject)
    openProject(plan.RootFolder);
end

% Set default task
plan.DefaultTasks = "test";

% Create shorthand for files/folders
codeFiles = fullfile("toolbox","*");
testFiles = fullfile("tests","*");
tbxPackagingFiles = fullfile("Example_ToolboxOptionsObject","*");
tbxOutputFile = pokerHandsToolboxDefinition().OutputFile;


% Configure tasks

plan("test").Inputs = [codeFiles,testFiles];
% plan("test").Dependencies = "check";

plan("toolbox").Inputs = [codeFiles,tbxPackagingFiles];
plan("toolbox").Outputs = tbxOutputFile;
plan("toolbox").Dependencies = "test";
% plan("toolbox").Dependencies = ["check","test"];

% Have the clean task try to clean the outputs of the toolbox task, if it exists
plan("clean").Inputs = matlab.buildtool.io.Glob(tbxOutputFile);

end


%% Tasks

function testTask(context)
% Run all tests
testFolder = fullfile(context.Plan.RootFolder, "tests");
results = runtests(testFolder, ...
    IncludeSubfolders = true, ...
    OutputDetail = "terse");
results.assertSuccess;
end

function toolboxTask(~)
% Package toolbox
packageMyToolbox();
end

function cleanTask(context)
% Remove auto-generated files

filesToClean = context.Task.Inputs.paths;
for ii = 1:numel(filesToClean)
    if isfile(filesToClean(ii))
        delete(filesToClean(ii));
        relPath = erase(filesToClean(ii),context.Plan.RootFolder+filesep);
        disp("Deleted: " + relPath);
    end
end

end

% function checkTask(context)
% % Identify code issues
% codeResults = codeIssues(context.Plan.RootFolder);
% 
% errInd = codeResults.Issues.Severity == "error";
% if any(errInd)
%     disp(" ");
%     disp("FAILED! Found critical errors in your code:");
%     disp(codeResults.Issues(errInd,:));
%     disp(" ");
% 
%     errMsg = "Code Analyzer found critical errors in your code." + newline + ...
%         "Please see diagnostics above.";
%     error(errMsg);
% end
% 
% end

