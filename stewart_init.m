%%
clear;
close all;
clc;

%%
run stewart_parameters.m

%% Define some constant values
deg2rad = pi/180;
x_axis = [1 0 0];
y_axis = [0 1 0];
z_axis = [0 0 1];

%% Connection points on base and top plate w.r.t. World frame at the center of the base plate
pos_base = zeros(6, 3);
pos_top = zeros(6, 3);

alpha_b = BP.leg.ang*deg2rad; % angle de d�calage par rapport � 120 deg (pour positionner les supports bases)
alpha_t = TP.leg.ang*deg2rad; % +- offset angle from 120 degree spacing on top

height = (stewart.h-BP.thickness-TP.thickness-Leg.sphere.bottom-Leg.sphere.top-SP.thickness.bottom-SP.thickness.top)*0.001 ; % 2 meter height in home configuration

radius_b = BP.leg.rad*0.001; % rayon emplacement support base
radius_t = TP.leg.rad*0.001; % top radius in meters

for i = 1:3
  % base points
  angle_m_b = (2*pi/3)* (i-1) - alpha_b;
  angle_p_b = (2*pi/3)* (i-1) + alpha_b;
  pos_base(2*i-1,:) =  [radius_b*cos(angle_m_b), radius_b*sin(angle_m_b), 0.0];
  pos_base(2*i,:) = [radius_b*cos(angle_p_b), radius_b*sin(angle_p_b), 0.0];

  % top points
  % Top points are 60 degrees offset
  angle_m_t = (2*pi/3)* (i-1) - alpha_t + 2*pi/6;
  angle_p_t = (2*pi/3)* (i-1) + alpha_t + 2*pi/6;
  pos_top(2*i-1,:) = [radius_t*cos(angle_m_t), radius_t*sin(angle_m_t), height];
  pos_top(2*i,:) = [radius_t*cos(angle_p_t), radius_t*sin(angle_p_t), height];
end

% permute pos_top points so that legs are end points of base and top points
pos_top = [pos_top(6,:); pos_top(1:5,:)]; %6th point on top connects to 1st on bottom
pos_top_tranform = pos_top - height*[zeros(6, 2),ones(6, 1)];

%% Compute points w.r.t. to the body frame in a 3x6 matrix
body_pts = pos_top' - height*[zeros(2,6);ones(1,6)];

%% leg vectors
legs = pos_top - pos_base;
leg_length = zeros(6, 1);
leg_vectors = zeros(6, 3);
for i = 1:6
  leg_length(i) = norm(legs(i,:));
  leg_vectors(i,:)  = legs(i,:) / leg_length(i);
end

Leg.lenght = 1000*leg_length(1)/1.5;

%% Calculate revolute and cylindrical axes
rev1 = zeros(6, 3);
rev2 = zeros(6, 3);
rev3 = zeros(6, 3);
rev4 = zeros(6, 3);
cyl1 = zeros(6, 3);
for i = 1:6
  rev1(i,:) = cross(leg_vectors(i,:), z_axis);
  rev1(i,:) = rev1(i,:) / norm(rev1(i,:));
  rev3(i,:) = rev1(i,:);

  rev2(i,:) = - cross(rev1(i,:), leg_vectors(i,:));
  rev2(i,:) = rev2(i,:) / norm(rev2(i,:));
  rev4(i,:) = rev2(i,:);

  cyl1(i,:) = leg_vectors(i,:);
end


%% Coordinate systems
lower_leg = struct('origin', [0 0 0], 'rotation', eye(3), 'end_point', [0 0 0]);
upper_leg = struct('origin', [0 0 0], 'rotation', eye(3), 'end_point', [0 0 0]);

for i = 1:6
  lower_leg(i).origin = pos_base(i,:) + (3/8)*legs(i,:);
  lower_leg(i).end_point = pos_base(i,:) +  (3/4)*legs(i,:);
  lower_leg(i).rotation = [rev1(i,:)', rev2(i,:)', cyl1(i,:)'];
  upper_leg(i).origin = pos_base(i,:) + (1-3/8)*legs(i,:);
  upper_leg(i).end_point = pos_base(i,:) +  (1/4)*legs(i,:);
  upper_leg(i).rotation = [rev1(i,:)', rev2(i,:)', cyl1(i,:)'];
end

%% Position Matrix
M_pos_base = pos_base + (height+(TP.thickness+Leg.sphere.top+SP.thickness.top+stewart.jacobian)*1e-3)*[zeros(6, 2),ones(6, 1)];

%% Compute Jacobian Matrix
J  = getJacobianMatrix(leg_vectors, M_pos_base);

