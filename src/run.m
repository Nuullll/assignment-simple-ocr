%% INOUT DIR

TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

mkdir(TRAIN_DIR, 'binarized');
mkdir(TEST_DIR, 'binarized');

%% preprocess train dataset
preprocess_train_dataset;

%% preprocess test dataset
preprocess_test_dataset;

%% test section
img = imread([TEST_DIR, '', '²¹³ä1.bmp']);
W = wiener2(rgb2gray(img), [3 3]);
bw = imbinarize(W, 'adaptive', 'ForegroundPolarity', 'dark', 'Sensitivity', 0.57);
figure;
imshowpair(img, W, 'montage');
figure;
imshowpair(W, bw, 'montage');