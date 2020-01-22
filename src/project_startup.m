

% When the project opens, a startup script is ran.
% The startup script is defined below and is exported to the =project_startup.m= script.

project = simulinkproject;
projectRoot = project.RootFolder;

myCacheFolder = fullfile(projectRoot, '.SimulinkCache');
myCodeFolder = fullfile(projectRoot, '.SimulinkCode');

Simulink.fileGenControl('set',...
    'CacheFolder', myCacheFolder,...
    'CodeGenFolder', myCodeFolder,...
    'createDir', true);

%% Load the Simscape Configuration
load('mat/conf_simscape.mat');
