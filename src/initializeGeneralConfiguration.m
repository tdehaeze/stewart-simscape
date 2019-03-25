function [stewart] = initializeGeneralConfiguration(opts_param)

opts = struct(...
    'H_tot',   90, ... % Height of the platform [mm]
    'H_joint', 15, ... % Height of the joints [mm]
    'H_plate', 10, ... % Thickness of the fixed and mobile platforms [mm]
    'R_bot',  100, ... % Radius where the legs articulations are positionned [mm]
    'R_top',  80,  ... % Radius where the legs articulations are positionned [mm]
    'a_bot',  10,  ... % Angle Offset [deg]
    'a_top',  40,  ... % Angle Offset [deg]
    'da_top', 0    ... % Angle Offset from 0 position [deg]
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

Aa = zeros(6, 3); % [mm]
Ab = zeros(6, 3); % [mm]
Bb = zeros(6, 3); % [mm]

for i = 1:3
    Aa(2*i-1,:) = [opts.R_bot*cos( pi/180*(120*(i-1) - opts.a_bot) ), ...
                   opts.R_bot*sin( pi/180*(120*(i-1) - opts.a_bot) ), ...
                   opts.H_plate+opts.H_joint];
    Aa(2*i,:)   = [opts.R_bot*cos( pi/180*(120*(i-1) + opts.a_bot) ), ...
                   opts.R_bot*sin( pi/180*(120*(i-1) + opts.a_bot) ), ...
                   opts.H_plate+opts.H_joint];

    Ab(2*i-1,:) = [opts.R_top*cos( pi/180*(120*(i-1) + opts.da_top - opts.a_top) ), ...
                   opts.R_top*sin( pi/180*(120*(i-1) + opts.da_top - opts.a_top) ), ...
                   opts.H_tot - opts.H_plate - opts.H_joint];
    Ab(2*i,:)   = [opts.R_top*cos( pi/180*(120*(i-1) + opts.da_top + opts.a_top) ), ...
                   opts.R_top*sin( pi/180*(120*(i-1) + opts.da_top + opts.a_top) ), ...
                   opts.H_tot - opts.H_plate - opts.H_joint];
end

Bb = Ab - opts.H_tot*[0,0,1];

stewart = struct();
  stewart.Aa = Aa;
  stewart.Ab = Ab;
  stewart.Bb = Bb;
  stewart.H_tot = opts.H_tot;
end
