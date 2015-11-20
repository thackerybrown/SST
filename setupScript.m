function [S,thePath] = setupScript()
% setupScript
% This script loads the paths for the experiment, and creates
% the variable thePath in the workspace.

%% system specific info
[~, hostname]=system('hostname');

exp_name = 'SST';
switch strcat(hostname)
    case 'sgagnon-laptop.local' % Steph's macbook pro in lab
        thePath.main = ['/Users/stephaniegagnon/Experiments/', exp_name];
    case 'sgagnon-desktop.stanford.edu'
        thePath.main = ['/Users/steph-backup/Experiments/', exp_name];
        thePath.felix = ['/Users/steph-backup/Code/felix/scripts'];
    case 'dn0a22125c.sunet'
        thePath.main = ['/Users/steph-backup/Experiments/', exp_name];
    case 'sgagnon-laptop.att.net'
        thePath.main = ['/Users/stephaniegagnon/Experiments/', exp_name];
    case 'Curtis'
        thePath.main = ['/Users/waglab/Experiments/steph/', exp_name];
        thePath.felix = ['/Users/waglab/Code/felix/scripts'];
    case 'Ari'
        thePath.main = ['/Users/waglab/Experiments/steph/', exp_name];    
        thePath.felix = ['/Users/waglab/Code/felix/scripts'];
    otherwise % steph
        thePath.main = ['/Users/sgagnon/Experiments/', exp_name];
        thePath.felix = ['/Users/sgagnon/Code/felix/scripts'];
end

if ismac
    S.separator = '/';
else
    S.separator = '\';
end

thePath.scripts = fullfile(thePath.main, 'scripts');
thePath.stim = fullfile(thePath.main, 'stimuli');
thePath.locstim = fullfile(thePath.main, 'loc_stimuli');
thePath.data = fullfile(thePath.main, 'data');
thePath.orderfiles = fullfile(thePath.main, 'orderfiles');
thePath.analysis = fullfile(thePath.main, 'analysis');


% Add relevant paths for this experiment
names = fieldnames(thePath);
for f = 1:length(names)
    eval(['addpath(genpath(thePath.' names{f} '))']);
    fprintf(['added ' names{f} '\n']);
end

addpath(genpath(thePath.felix));

cd(thePath.main);
