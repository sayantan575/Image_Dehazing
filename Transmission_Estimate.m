function t = Transmission_Estimate(hazy_image, A)
% Estimates the transmission map using dark channel prior
[r,c,m] = size(hazy_image);
w = 0.95;                 % haze preserving factor

y = zeros(r,c,m);

for i = 1:r
    for j = 1:c
        for k = 1:m
            y(i,j,k) = hazy_image(i,j,k) / A(k);
        end
    end
end

Dark_Channel_y = Dark_Channel(y);
t = 1 - w .* Dark_Channel_y;

t = max(t, 0.1);          % lower bound
end
