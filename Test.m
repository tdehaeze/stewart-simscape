%% Variable parameters
BP_leg_radius = 100:10:150;
TP_leg_radius = 50:10:100;
BP_leg_ang = 0:1:30;
TP_leg_ang = 0:1:30;

%% 
intervalle1=10e-6;
intervalle2=10e-3;
% variation=1e-3;

%% Study the effect of the radius of the top platform position of the legs
max_disp   = zeros(length(BP_leg_radius),length(TP_leg_radius),length(BP_leg_ang),length(TP_leg_ang), 6);
stiffness  = zeros(length(BP_leg_radius),length(TP_leg_radius),length(BP_leg_ang),length(TP_leg_ang), 6, 6);

for Blri = 1:length(BP_leg_radius)
    for Tlri = 1:length(TP_leg_radius)
        for Blai = 1:length(BP_leg_ang)
            for Tlai = 1:length(TP_leg_ang)
                BP.leg.rad = BP_leg_radius(Blri);
                TP.leg.rad = TP_leg_radius(Tlri);
                BP.leg.ang = BP_leg_ang(Blai);
                TP.leg.ang = TP_leg_ang(Tlai);
                run stewart_init.m;
                max_disp(Blri,Tlri,Blai,Tlai, :) = getMaxPureDisplacement(Leg, J)';
                stiffness(Blri,Tlri,Blai,Tlai, :, :) = getStiffnessMatrix(Leg, J);
            end
        end
    end
end

%%
M = min(max_disp(:, : , :, :, 1), max_disp(:, : , :, :, 2));
[C,I] = max(M(:));

[I1,I2,I3,I4] = ind2sub(size(max_disp(:, : , :, :, 3)),I);
BP_leg_radius(I1)
TP_leg_radius(I2)
BP_leg_ang(I3)
TP_leg_ang(I4)

% %%
% for Blri = 1:length(BP_leg_radius)
%     for Tlri = 1:length(TP_leg_radius)
%         for Blai = 1:length(BP_leg_ang)
%             for Tlai = 1:length(TP_leg_ang)
%                 if max_disp==intervalle1
%                    i=i+1;
%                    s1(1,i)=BP_leg_radius(Blri);
%                    s1(2,i)=TP_leg_radius(Tlri);
%                    s1(3,i)=BP_leg_ang(Blai);
%                    s1(4,i)=TP_leg_ang(Tlai);
%                 else
%                 end
%             end
%         end
%     end
% end
%
