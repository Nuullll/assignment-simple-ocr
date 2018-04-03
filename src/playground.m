%% INOUT DIR

TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

%% show preprocessed images

D = dir([TEST_DIR, 'binarized/', '*.bmp']);
images = {D.name};

for i = 1:length(images)
    name = images{i};
    
    img = imread([TEST_DIR, 'binarized/', name]);
    d = double(img);
    
    occur = sum(d,2)/size(img,2);
    
    figure(1);
    subplot(5,2,i);
    plot(occur);
    [~, idx] = findpeaks(occur, 'MinPeakHeight', 0.9, 'MinPeakWidth', 3, 'Threshold', 0.007);
    
    rows = cell(length(idx)+1,1);
    rows{1} = img(1:idx(1),:);
    for j = 1:length(idx)-1
        rows{j+1} = img(idx(j)+1:idx(j+1),:);
    end
    rows{end} = img(idx(end):end,:);
    
    occuc = sum(d,1)/size(img,1);
    figure(2);
    subplot(5,2,i);
    plot(occuc);
    findpeaks(occuc, 'MinPeakHeight', 0.9, 'MinPeakDistance', 15);
end