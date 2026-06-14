function contrast = Contrast_Map(I)
    gray = rgb2gray(I);
    contrast = stdfilt(gray, true(5));
    contrast = mat2gray(contrast);
end
