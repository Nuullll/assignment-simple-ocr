function display_segmentations( segmentations, img )
% show segmentations

figure;
count = length(segmentations);
for k = 1:count
    subplot(1,count,k);
    imshow(img(segmentations{k}.row_range, segmentations{k}.col_range));
end

end

