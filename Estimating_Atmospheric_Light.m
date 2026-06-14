function A = Estimating_Atmospheric_Light(hazy_image, dark)
% Estimates atmospheric light from the brightest pixels of the dark channel
[r, c, m] = size(hazy_image);
num_pixels = r * c;
num_top = floor(0.001 * num_pixels);   % top 0.1%

dark_vec = reshape(dark, num_pixels, 1);
hazy_vec = reshape(hazy_image, num_pixels, m);

[~, idx] = sort(dark_vec, 'descend');
top_idx = idx(1:num_top);

max_intensity = 0;
best_pixel = top_idx(1);

for i = 1:num_top
    intensity = sum(hazy_vec(top_idx(i), :));
    if intensity > max_intensity
        max_intensity = intensity;
        best_pixel = top_idx(i);
    end
end

A = hazy_vec(best_pixel, :);
end
