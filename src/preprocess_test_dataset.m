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
    conn = bwconncomp(~bw_img);
    conn_list = conn.PixelIdxList;
    for k = 1:length(conn_list)
        if length(conn_list{k}) <= numel(img)/1000
            bw_img(conn_list{k}) = 1;
        end
    end
    
    imwrite(bw_img, [TEST_DIR, 'binarized/', name]);
end