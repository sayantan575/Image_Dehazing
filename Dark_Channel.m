function J_dark = Dark_Channel(I)
% Computes the dark channel of an RGB image
% I : input image (double, 0-1)
[r,c,m] = size(I);
patch_size = 15;                 % default patch size
pad = floor(patch_size/2);

% Pad the image
I_padded = padarray(I, [pad pad], 'replicate', 'both');
J_dark = zeros(r,c);

% Compute dark channel
for i = 1:r
    for j = 1:c
        patch = I_padded(i:i+patch_size-1, j:j+patch_size-1, :);
        J_dark(i,j) = min(patch(:));
    end
end
end
