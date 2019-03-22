% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:1]]
function [sys] = identifyPlant(opts_param)
% identifyPlant:1 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:2]]
%% Default values for opts
opts = struct();

%% Populate opts with input parameters
if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end
% identifyPlant:2 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:3]]
options = linearizeOptions;
options.SampleTime = 0;
% identifyPlant:3 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:4]]
mdl = 'stewart';
% identifyPlant:4 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:5]]
%% Inputs
io(1) = linio([mdl, '/F'],  1, 'input'); % Cartesian forces
io(2) = linio([mdl, '/Fl'], 1, 'input'); % Leg forces
io(3) = linio([mdl, '/Fd'], 1, 'input'); % Direct forces
io(4) = linio([mdl, '/Dw'], 1, 'input'); % Base motion

%% Outputs
io(5) = linio([mdl, '/Dm'],  1, 'output'); % Relative Motion
io(6) = linio([mdl, '/Dlm'], 1, 'output'); % Displacement of each leg
io(7) = linio([mdl, '/Flm'], 1, 'output'); % Force sensor in each leg
io(8) = linio([mdl, '/Xm'],  1, 'output'); % Absolute motion of platform
% identifyPlant:5 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:6]]
G = linearize(mdl, io, 0);
% identifyPlant:6 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:7]]
G.InputName  = {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz', ...
                'F1', 'F2', 'F3', 'F4', 'F5', 'F6', ...
                'Fdx', 'Fdy', 'Fdz', 'Mdx', 'Mdy', 'Mdz', ...
                'Dwx', 'Dwy', 'Dwz', 'Rwx', 'Rwy', 'Rwz'};
G.OutputName = {'Dxm', 'Dym', 'Dzm', 'Rxm', 'Rym', 'Rzm', ...
                'D1m', 'D2m', 'D3m', 'D4m', 'D5m', 'D6m', ...
                'F1m', 'F2m', 'F3m', 'F4m', 'F5m', 'F6m', ...
                'Dxtm', 'Dytm', 'Dztm', 'Rxtm', 'Rytm', 'Rztm'};
% identifyPlant:7 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:8]]
sys.G_cart = minreal(G({'Dxm', 'Dym', 'Dzm', 'Rxm', 'Rym', 'Rzm'}, {'Fx', 'Fy', 'Fz', 'Mx', 'My', 'Mz'}));
sys.G_forc = minreal(G({'F1m', 'F2m', 'F3m', 'F4m', 'F5m', 'F6m'}, {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'}));
sys.G_legs = minreal(G({'D1m', 'D2m', 'D3m', 'D4m', 'D5m', 'D6m'}, {'F1', 'F2', 'F3', 'F4', 'F5', 'F6'}));
sys.G_tran = minreal(G({'Dxtm', 'Dytm', 'Dztm', 'Rxtm', 'Rytm', 'Rztm'}, {'Dwx', 'Dwy', 'Dwz', 'Rwx', 'Rwy', 'Rwz'}));
sys.G_comp = minreal(G({'Dxm', 'Dym', 'Dzm', 'Rxm', 'Rym', 'Rzm'}, {'Fdx', 'Fdy', 'Fdz', 'Mdx', 'Mdy', 'Mdz'}));
sys.G_iner = minreal(G({'Dxtm', 'Dytm', 'Dztm', 'Rxtm', 'Rytm', 'Rztm'}, {'Fdx', 'Fdy', 'Fdz', 'Mdx', 'Mdy', 'Mdz'}));
% sys.G_all  = minreal(G);
% identifyPlant:8 ends here

% [[file:~/MEGA/These/Matlab/Simscape/stewart-simscape/identification.org::*identifyPlant][identifyPlant:9]]
end
% identifyPlant:9 ends here
