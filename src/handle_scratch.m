TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

img = imread([TEST_DIR, '', '划痕.bmp']);

% find background color
bin_width = 10;

[H,edges] = histcounts(img, 'BinWidth', bin_width);
[~,I] = max(H);
bg_color = edges(I(1)) + bin_width/2;

% get scratch color range
sc_color_l = edges(1);
sc_color_h = edges(4);

% replace scratch color
img(img<=sc_color_h) = bg_color;

imwrite(img, [TEST_DIR, '', '划痕处理.bmp']);