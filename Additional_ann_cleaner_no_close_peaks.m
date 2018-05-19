function ann_indxs=Additional_ann_cleaner_no_close_peaks(t,vec,sample_rate,ann_indxs,stds)
time_to_explore=3; %sec
hot_spot=0.150; %sec
hot_spot_samples=floor(hot_spot*sample_rate);
ann_indxs_filter=[];
samples_window=floor(time_to_explore/2*sample_rate);
for counter=1:numel(ann_indxs)
    starting_point=max((ann_indxs(counter)-samples_window),1);
    ending_point=min((ann_indxs(counter)+samples_window),numel(vec));
    starting_point_hot_spot=max((ann_indxs(counter)-hot_spot_samples),1);
    ending_point_hot_spot=min((ann_indxs(counter)+hot_spot_samples),numel(vec));    
    mean_period=mean(vec(starting_point:ending_point));
    std_period=std(vec((starting_point:ending_point)));

    if (max(    abs(vec(starting_point_hot_spot:ending_point_hot_spot)-mean_period) )<stds*std_period)
        ann_indxs_filter(counter)=0;
        t(ann_indxs(counter))
    else
        ann_indxs_filter(counter)=1;
    end
    
end
ann_indxs=ann_indxs(ann_indxs_filter>0);
if numel(ann_indxs)>5
ann_indxs_diffs=diff(ann_indxs);
ann_indxs(find(ann_indxs_diffs<(sample_rate/10))+1)=[];
end
