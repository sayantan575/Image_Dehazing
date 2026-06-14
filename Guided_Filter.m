function q = Guided_Filter(I, p, r, eps)
% I   : guidance image (RGB or grayscale)
% p   : filtering input image
% r   : window radius
% eps : regularization parameter

if size(I,3) == 3
    I = rgb2gray(I);  % Convert to grayscale for guidance
end

I = double(I);
p = double(p);
w = 2*r + 1;

% Local means
mean_I = imboxfilt(I, w);
mean_p = imboxfilt(p, w);
mean_Ip = imboxfilt(I .* p, w);

% Covariance and variance
cov_Ip = mean_Ip - mean_I .* mean_p;
mean_II = imboxfilt(I .* I, w);
var_I = mean_II - mean_I .* mean_I;

% Linear coefficients
a = cov_Ip ./ (var_I + eps);
b = mean_p - a .* mean_I;

% Mean of coefficients
mean_a = imboxfilt(a, w);
mean_b = imboxfilt(b, w);

% Output
q = mean_a .* I + mean_b;
end
