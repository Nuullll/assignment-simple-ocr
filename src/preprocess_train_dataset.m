%% preprocess train dataset
D = dir([TRAIN_DIR, '*.bmp']);
images = {D.name};

for i = 1:length(images)
    name = images{i};
    
    img = imread([TRAIN_DIR, name]);
    bw_img = imbinarize(img);
    
    imwrite(bw_img, [TRAIN_DIR, 'binarized/', name]);
end
