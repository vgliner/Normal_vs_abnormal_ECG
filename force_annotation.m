function forced_ann_indx=force_annotation(signal_chunk)
[~,forced_ann_indx]=max(abs(signal_chunk(numel(signal_chunk)*0.1:numel(signal_chunk)*0.9)));
forced_ann_indx=floor(numel(signal_chunk)*0.1)+forced_ann_indx-1;