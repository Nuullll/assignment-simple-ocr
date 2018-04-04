TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

img = imread([TEST_DIR, '', '划痕.bmp']);

% find background color
H = histogram(img, 'BinWidth', 10);
[~,I] = max(H.Values);
bg_color = H.BinEdges(I(1)) + H.BinWidth/2;

% get scratch color range
sc_color_l = H.BinEdges(1);
sc_color_h = H.BinEdges(4);

% replace scratch color
img(img<=sc_color_h) = bg_color;

figure;imshow(img);

imwrite(img, [TEST_DIR, '', '划痕处理.bmp']);