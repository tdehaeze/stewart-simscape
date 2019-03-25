function [stewart] = computeGeometricalProperties(stewart, opts_param)

opts = struct(...
    'Jd_pos', [0, 0, 30], ... % Position of the Jacobian for displacement estimation from the top of the mobile platform [mm]
    'Jf_pos', [0, 0, 30]  ... % Position of the Jacobian for force location from the top of the mobile platform [mm]
    );

if exist('opts_param','var')
    for opt = fieldnames(opts_param)'
        opts.(opt{1}) = opts_param.(opt{1});
    end
end

leg_length = zeros(6, 1); % [mm]
leg_vectors = zeros(6, 3);

legs = stewart.Ab - stewart.Aa;

for i = 1:6
    leg_length(i) = norm(legs(i,:));
    leg_vectors(i,:) = legs(i,:) / leg_length(i);
end

stewart.Rm = struct('R', eye(3));

for i = 1:6
  sx = cross(leg_vectors(i,:), [1 0 0]);
  sx = sx/norm(sx);

  sy = -cross(sx, leg_vectors(i,:));
  sy = sy/norm(sy);

  sz = leg_vectors(i,:);
  sz = sz/norm(sz);

  stewart.Rm(i).R = [sx', sy', sz'];
end

Jd = zeros(6);

for i = 1:6
  Jd(i, 1:3) = leg_vectors(i, :);
  Jd(i, 4:6) = cross(0.001*(stewart.Bb(i, :) - opts.Jd_pos), leg_vectors(i, :));
end

stewart.Jd = Jd;
stewart.Jd_inv = inv(Jd);

Jf = zeros(6);

for i = 1:6
  Jf(i, 1:3) = leg_vectors(i, :);
  Jf(i, 4:6) = cross(0.001*(stewart.Bb(i, :) - opts.Jf_pos), leg_vectors(i, :));
end

stewart.Jf = Jf;
stewart.Jf_inv = inv(Jf);

end
