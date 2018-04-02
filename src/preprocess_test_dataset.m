%% preprocess test dataset
D = dir([TEST_DIR, '*.bmp']);
images = {D.name};

for i = 1:length(images)
    name = images{i};
    
    img = imread([TEST_DIR, name]);
    gray = rgb2gray(img);
    denoise = wiener2(gray, [3 5]);
    bw_img = imbinarize(denoise, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.57);
    
    % remove small noise components
    [a,b] = size(bw_img);
    d1 = diff(bw_img);
    d2 = diff(bw_img,1,2);
    du = [-1*ones(1,b);d1];
    dd = [-d1;-1*ones(1,b)];
    dl = [-1*ones(a,1),d2];
    dr = [-d2,-1*ones(a,1)];
    bw_img((du+dd+dl+dr)<=-3) = 1;
    
    imwrite(bw_img, [TEST_DIR, 'binarized/', name]);
end