% Wrapper script for SST scripts
% This script loads the paths for the experiment, creates a stimulus order
% file for a given subject, and runs the task
%
% written by SG 06/18/15
% github repo: https://github.com/sgagnon/SST
%

% Screen('Preference', 'SkipSyncTests', 1)

% define and load paths
[S,thePath] = setupScript();

% define subject-specific info
subID = input('What is the subject ID? ','s');

% determine whether stims need to be assigned and order lists created
cd(thePath.orderfiles);
useStims = 0;
if exist(fullfile(thePath.orderfiles,subID,sprintf('%s_stims.mat',subID)),'file')
    useStims = input('Use existing stim file? (1=yes,0=no) ');
end

cd(thePath.scripts);
if useStims == 0 % create order lists, then run task
    sst_makeOrder(subID,thePath);
    sst_run(subID,thePath);
    
elseif useStims == 1 % run task
    sst_run(subID,thePath);
end

clear all;