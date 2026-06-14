
clc;
clear;
close all;

% ---------------- READ HAZY IMAGE ----------------
hazy_image = im2double(imread('School.jpg'));

% ---------------- DEHAZING PIPELINE ----------------

% Dark Channel
J_dark = Dark_Channel(hazy_image);

% Atmospheric Light
A = Estimating_Atmospheric_Light(hazy_image, J_dark);

% Transmission Estimate
t = Transmission_Estimate(hazy_image, A);

% Transmission Refinement using Guided Filter
window_size = 15;
eps = 1e-3;
t_refined = Guided_Filter(hazy_image, t, window_size, eps);

% Recover Haze-Free Image
J = Recovering_Scene_Radiance(hazy_image, A, t_refined);
% Haze thickness map
haze_thickness = 1 - t_refined;

% ---------------- ADDITIONAL ANALYSIS (NO GT) ----------------

% Depth Map
depth = Depth_Map(t_refined);

% Contrast Map
contrast = Contrast_Map(J);

% Entropy (No-reference metric)
entropy_val = entropy(rgb2gray(J));

% ---------------- RELATIVE QUALITY METRICS ----------------
% (Using hazy image as reference)

ref_gray = rgb2gray(hazy_image);
J_gray   = rgb2gray(J);

% PSNR (built-in)
psnr_val = psnr(J_gray, ref_gray);

% FID (simplified custom function)
fid_val = FID_Simple(ref_gray, J_gray);

% Display values
disp(['Entropy = ', num2str(entropy_val)]);
disp(['PSNR (relative) = ', num2str(psnr_val), ' dB']);
disp(['FID  (relative) = ', num2str(fid_val)]);

% ---------------- FIGURE 1: DEHAZING PROCESS ----------------


figure('Name','Dehazing Pipeline','NumberTitle','off');

subplot(2,3,1);
imshow(hazy_image);
title('Hazy Image');
axis off

subplot(2,3,2);
imshow(J_dark);
title('Dark Channel');
axis off

subplot(2,3,3);
imshow(t);
title('Transmission Map');
axis off

subplot(2,3,4);
imshow(t_refined);
title('Refined Transmission');
axis off

subplot(2,3,5);
imshow(haze_thickness,[]);
title('Haze Thickness Map');
axis off

subplot(2,3,6);
imshow(J);
title('Dehazed Image');
axis off


% ---------------- FIGURE 2: ANALYSIS RESULTS ----------------
figure('Name','Analysis Results','NumberTitle','off');

subplot(1,3,1);
imshow(depth,[]);
title('Depth Map');
axis off

subplot(1,3,2);
imshow(contrast,[]);
title('Contrast Map');
axis off

subplot(1,3,3);
imshow(J);
title('Dehazed Image');
axis off
% ---------------- PIXEL VALUE GRAPH ----------------
Pixel_Value_Graph(hazy_image, J);
% ---------------- HISTOGRAM ANALYSIS ----------------
Histogram_Comparison(hazy_image, J);
% ---------------- NOISE ANALYSIS ----------------
Noise_Analysis(hazy_image, J);