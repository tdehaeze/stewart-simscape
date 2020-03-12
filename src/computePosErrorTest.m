function [Edx, Edy, Edz, Erx, Ery, Erz] = computePosErrorTest(Dxr, Dyr, Dzr, Rxr, Ryr, Rzr, Dxm, Dym, Dzm, Rxm, Rym, Rzm)

%% Measured Pose
WTm = zeros(4,4);

WTm(1:3, 1:3) = [cos(Rzm) -sin(Rzm) 0;
     sin(Rzm)  cos(Rzm) 0;
     0        0         1] * ...
    [cos(Rym)  0        sin(Rym);
     0        1        0;
     -sin(Rym)  0        cos(Rym)] * ...
    [1        0        0;
     0        cos(Rxm) -sin(Rxm);
     0        sin(Rxm)  cos(Rxm)];
WTm(1:4, 4) = [Dxm ; Dym ; Dzm; 1];

%% Reference Pose
WTr = zeros(4,4);

WTr(1:3, 1:3) = [cos(Rzr) -sin(Rzr) 0;
     sin(Rzr)  cos(Rzr) 0;
     0        0         1] * ...
    [cos(Ryr)  0        sin(Ryr);
     0        1        0;
     -sin(Ryr)  0        cos(Ryr)] * ...
    [1        0        0;
     0        cos(Rxr) -sin(Rxr);
     0        sin(Rxr)  cos(Rxr)];
WTr(1:4, 4) = [Dxr ; Dyr ; Dzr; 1];

WTv = eye(4);
WTv(1:3, 4) = WTm(1:3, 4);

%% Wanted pose expressed in a frame corresponding to the actual measured pose
MTr = [WTm(1:3,1:3)', -WTm(1:3,1:3)'*WTm(1:3,4) ; 0 0 0 1]*WTr;

%% Wanted pose expressed in a frame coincident with the actual position but with no rotation
VTr = [WTv(1:3,1:3)', -WTv(1:3,1:3)'*WTv(1:3,4) ; 0 0 0 1] * WTr;

%% Extract Translations and Rotations from the Homogeneous Matrix
  T = MTr;
  Edx = T(1, 4);
  Edy = T(2, 4);
  Edz = T(3, 4);

  % The angles obtained are u-v-w Euler angles (rotations in the moving frame)
  Ery = atan2( T(1, 3),          sqrt(T(1, 1)^2 + T(1, 2)^2));
  Erx = atan2(-T(2, 3)/cos(Ery), T(3, 3)/cos(Ery));
  Erz = atan2(-T(1, 2)/cos(Ery), T(1, 1)/cos(Ery));
end
