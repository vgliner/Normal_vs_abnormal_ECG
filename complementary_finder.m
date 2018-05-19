function ann_indxs=complementary_finder(t,input_signal,sample_rate,current_ann_vec)
% The function goes over the current annotation vector and finds big gaps.
% In case of gap larger than threshold, the function forces annotation in
% between
ann_indxs=current_ann_vec;
maximal_time_between_beats=1.83; %[sec] 1.8
max_samples_between_beats=maximal_time_between_beats*sample_rate;
is_missing=1;
while (is_missing>0)
    is_missing=is_ann_missed(ann_indxs,max_samples_between_beats);
        try
        forced_ann_indx=force_annotation(input_signal(ann_indxs(is_missing):ann_indxs(is_missing)+max_samples_between_beats));
        catch
            return
        end
        s=size(ann_indxs);
        if s(1)>s(2)
            ann_indxs=ann_indxs';
        end
    ann_indxs=[ann_indxs (ann_indxs(is_missing)+forced_ann_indx)];
    ann_indxs=sort(ann_indxs);
end
