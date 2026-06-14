function Histogram_Comparison(hazy_image, J)

figure('Name','RGB Histogram Comparison','NumberTitle','off');

% Hazy Image
subplot(2,1,1);

r = imhist(hazy_image(:,:,1));
g = imhist(hazy_image(:,:,2));
b = imhist(hazy_image(:,:,3));

plot(r,'r','LineWidth',1.5);
hold on;
plot(g,'g','LineWidth',1.5);
plot(b,'b','LineWidth',1.5);
hold off;

title('Hazy Image RGB Histogram');
xlabel('Pixel Intensity');
ylabel('Frequency');
legend('Red','Green','Blue');

% Dehazed Image
subplot(2,1,2);

r = imhist(J(:,:,1));
g = imhist(J(:,:,2));
b = imhist(J(:,:,3));

plot(r,'r','LineWidth',1.5);
hold on;
plot(g,'g','LineWidth',1.5);
plot(b,'b','LineWidth',1.5);
hold off;

title('Enhanced Image RGB Histogram');
xlabel('Pixel Intensity');
ylabel('Frequency');
legend('Red','Green','Blue');

end