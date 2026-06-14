function Noise_Analysis(original_image, dehazed_image)

% ---------------- CONVERT TO GRAYSCALE ----------------
original_gray = rgb2gray(original_image);
dehazed_gray  = rgb2gray(dehazed_image);

% ---------------- PSNR ----------------
psnr_val = psnr(dehazed_gray, original_gray);

% ---------------- MSE ----------------
mse_val = immse(dehazed_gray, original_gray);

% ---------------- SNR ----------------
signal_power = mean(dehazed_image(:).^2);
noise_power  = mean((dehazed_image(:) - original_image(:)).^2);

snr_val = 10 * log10(signal_power / noise_power);

% ---------------- DISPLAY VALUES ----------------
fprintf('\n====================================\n');
fprintf('        NOISE ANALYSIS RESULTS\n');
fprintf('====================================\n');
fprintf('PSNR = %.4f dB\n', psnr_val);
fprintf('MSE  = %.6f\n', mse_val);
fprintf('SNR  = %.4f dB\n', snr_val);
fprintf('====================================\n');

% ---------------- RESULT FIGURE ----------------
figure('Name','Noise Analysis','NumberTitle','off');

subplot(1,2,1);
imshow(original_image);
title('Input Hazy Image');
axis off

subplot(1,2,2);
imshow(dehazed_image);
title('Dehazed Image');
axis off

sgtitle(sprintf('PSNR = %.2f dB   |   MSE = %.6f   |   SNR = %.2f dB', ...
    psnr_val, mse_val, snr_val));

end