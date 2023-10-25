function plan = buildfile
import matlab.buildtool.tasks.*

plan = buildplan(localfunctions);

% Set default task
plan.DefaultTasks = "test";

% Configure tasks
% plan("check") = CodeIssuesTask();

codeFiles = fullfile("toolbox","*");
plan("test") = TestTask("tests", ...
    SourceFiles=codeFiles, ...
    OutputDetail="terse");     
% plan("test").Dependencies="check";

tbxPackagingFiles = fullfile("Example_ScriptableToolboxPackaging","*");
tbxOutputFile = pokerHandsToolboxDefinition().OutputFile;
plan("toolbox").Inputs = [codeFiles,tbxPackagingFiles];
plan("toolbox").Outputs = tbxOutputFile;
plan("toolbox").Dependencies = "test";
% plan("toolbox").Dependencies = ["check","test"];

% Clean the task outputs
plan("clean") = CleanTask;

end


%% Tasks

function toolboxTask(~)
% Package toolbox
packageMyToolbox();
end
