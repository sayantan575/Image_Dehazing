function Pixel_Value_Graph(hazy_image, J)

% Convert to grayscale
hazy_gray = rgb2gray(hazy_image);
J_gray = rgb2gray(J);

% Select middle row
row = round(size(hazy_gray,1)/2);

figure('Name','Pixel Intensity Comparison','NumberTitle','off');

plot(hazy_gray(row,:), 'LineWidth',1.5);
hold on;
plot(J_gray(row,:), 'LineWidth',1.5);

legend('Hazy Image','Dehazed Image');
title('Pixel Intensity Comparison (Middle Row)');
xlabel('Pixel Position');
ylabel('Intensity Value');
grid on;

end
