%% INOUT DIR

TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

%% show preprocessed images
figure;
D = dir([TEST_DIR, 'binarized/', '*.bmp']);
images = {D.name};

for i = 1:length(images)
    name = images{i};
    
    img = imread([TEST_DIR, 'binarized/', name]);
    
    subplot(5,2,i);
    imshow(img);
end