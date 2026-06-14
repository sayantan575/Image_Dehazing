function J = Recovering_Scene_Radiance(hazy_image, A, t)
% Recovers haze-free image from hazy image
[r,c,m] = size(hazy_image);
t0 = 0.1;

J = zeros(r,c,m);

for i = 1:r
    for j = 1:c
        for k = 1:m
            max_t = max(t(i,j), t0);
            J(i,j,k) = ((hazy_image(i,j,k) - A(k)) / max_t) + A(k);
        end
    end
end

% Clamp values
J = min(max(J,0),1);
end
