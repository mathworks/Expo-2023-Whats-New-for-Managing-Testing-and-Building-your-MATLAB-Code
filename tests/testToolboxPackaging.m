classdef testToolboxPackaging < matlab.unittest.TestCase

    methods (Test)
        % Test methods

        function toolboxPackagingTest(testCase)
            % Test that toolbox packaging does not error and that we are
            % left with the expected toolbox

            % Create a temporary folder
            import matlab.unittest.fixtures.TemporaryFolderFixture
            folderFixture = testCase.applyFixture(TemporaryFolderFixture);
            
            % Change MLTBX file destination to temporary folder
            toolboxOpts = pokerHandToolboxDefinition();
            [~,fileName,fileExt] = fileparts(toolboxOpts.OutputFile);
            toolboxOpts.OutputFile = fullfile(folderFixture.Folder,fileName+fileExt);

            % Package toolbox and check that the toolbox file was created
            packageMyToolbox(toolboxOpts,DisplayOutputFilePath=false);
            tbxExistsAfterTest = isfile(toolboxOpts.OutputFile);
            testCase.assertTrue(tbxExistsAfterTest);
        end
        
    end

end

