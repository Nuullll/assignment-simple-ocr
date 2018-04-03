%% INOUT DIR

TRAIN_DIR = '../train/';
TEST_DIR = '../TEST/';

mkdir(TRAIN_DIR, 'binarized');
mkdir(TEST_DIR, 'binarized');

%% preprocess train dataset
preprocess_train_dataset;

%% preprocess test dataset
preprocess_test_dataset;

%% read train model
D = dir([TRAIN_DIR, 'binarized/', '*.bmp']);
images = {D.name};
models = struct('label',{},'image',{});

for i = 1:length(images)
    name = images{i};
    label = extractBefore(name, '.');
    img = imread([TRAIN_DIR, 'binarized/', name]);
    
    models{end+1} = struct('label',label,'image',img);
end

model_count = length(models);

%% Processing: loop through test dataset
D = dir([TEST_DIR, 'binarized/', '*.bmp']);
images = {D.name};
figure;
for i = 1:length(images)
    name = images{i};
    
    img = imread([TEST_DIR, 'binarized/', name]);
    dimg = double(img);
    [a,b] = size(img);
    
    %% Processing: linear segmentation

    % row-wise segmentation
    duty_r = sum(dimg,2)/b;
    [~, idx] = findpeaks(duty_r, 'MinPeakHeight', 0.9, 'MinPeakWidth', 3, 'Threshold', 0.007);
    row_count = length(idx)+1;

    rows = struct('row_range',{});
    rows{1} = struct('row_range',1:idx(1));
    for j = 1:row_count-2
        rows{end+1} = struct('row_range',idx(j)+1:idx(j+1));
    end
    rows{end+1} = struct('row_range',idx(end):a);
    

    % column-wise segmentation
    segmentations = struct('row_range',{},'col_range',{});
    % loop through each row
    for row_idx = 1:row_count
        row_range = rows{row_idx}.row_range;
        row_slice = dimg(row_range,:);
        duty_c = sum(row_slice,1)/size(row_slice,1);
        [~, idx] = findpeaks(duty_c, 'MinPeakHeight', 0.9, 'MinPeakDistance', 12);
        col_count = length(idx)+1;

        segmentations{end+1} = struct('row_range',row_range, 'col_range',1:idx(1));
        for j = 1:col_count-2
            segmentations{end+1} = struct('row_range',row_range, 'col_range',idx(j)+1:idx(j+1));
        end
        segmentations{end+1} = struct('row_range',row_range, 'col_range',idx(end):b);
    end

    %% Processing: recognize each segmentation
%     display_segmentations(segmentations, img);

    seg_count = length(segmentations);
    % cut white edges of each segmentation
    for seg_idx = 1:seg_count
        row_range = segmentations{seg_idx}.row_range;
        col_range = segmentations{seg_idx}.col_range;
        piece = dimg(row_range, col_range);
        % remove small connected components
        conn = bwconncomp(~piece);
        conn_list = conn.PixelIdxList;
        for k = 1:length(conn_list)
            if length(conn_list{k}) <= numel(img)/1000
                piece(conn_list{k}) = 1;
            end
        end
        
        [I,J] = find(piece==0);
        
        segmentations{seg_idx}.row_range = row_range(min(I):max(I));
        segmentations{seg_idx}.col_range = col_range(min(J):max(J));
    end
    
    % discard abnormal segmentations (too small, too white)
    del_idx = [];

%     display_segmentations(segmentations, img);

    for k = 1:seg_count
        piece = dimg(segmentations{k}.row_range, segmentations{k}.col_range);
        [h,w] = size(piece);

        if h <=5 || w <= 5 || sum(sum(piece))/(h*w) > 0.8
            del_idx(end+1) = k;
        end
    end
    segmentations(del_idx) = [];

%     display_segmentations(segmentations, img);

    % do correlation between models and each segmentation
    % resize to align segmentation with model
    seg_count = length(segmentations);
    rec_str = '';
    
    for k = 1:seg_count
        max_corr = 0;
        label = '';
        
        seg = segmentations{k};
        seg_h = length(seg.row_range);
        seg_w = length(seg.col_range);
        
        for m = 1:model_count
            model = models{m};
            [model_h, model_w] = size(model.image);
            
            H = max(seg_h, model_h);
            W = max(seg_w, model_w);
            
            seg_img = double(imbinarize(imresize(dimg(seg.row_range,seg.col_range),[H W], 'nearest')));
            model_img = double(imbinarize(imresize(double(model.image),[H W],'nearest')));
            
            corr = sum(sum(seg_img.*model_img))/(norm(seg_img)*norm(model_img));
            
            if corr > max_corr
                max_corr = corr;
                label = model.label;
            end
        end
        
        rec_str(end+1) = label;
        
    end

    subplot(5,2,i);
    imshow(img);
    title(rec_str);

end
