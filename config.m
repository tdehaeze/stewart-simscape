%%
addpath('active_damping');
addpath('analysis');
addpath('identification');
addpath('library');
addpath('studies');
addpath('src');

%%
freqs = logspace(-1, 3, 1000);
save_fig = false;
save('./mat/config.mat', 'freqs', 'save_fig');
