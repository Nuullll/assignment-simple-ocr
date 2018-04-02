%% preprocess test dataset
D = dir([TEST_DIR, '*.bmp']);
images = {D.name};

for i = 1:length(images)
    name = images{i};
    
    img = imread([TEST_DIR, name]);
    gray = rgb2gray(img);
    denoise = wiener2(gray, [3 5]);
    bw_img = imbinarize(denoise, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.55);
    
    imwrite(bw_img, [TEST_DIR, 'binarized/', name]);
end