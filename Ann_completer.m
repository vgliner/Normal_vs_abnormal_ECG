function ann_indxs=Ann_completer(t,processed_signal,sample_rate,ann_indxs,stds_num)
%% Add annotations with high derivative 
input_signal_diff=diff(smooth(processed_signal,7));
input_signal_diff=medfilt1m(input_signal_diff,3,0);
mean_abs_sig_diff=mean(abs(input_signal_diff));
std_abs_sig_diff=std(abs(input_signal_diff));

ann_idxs_added=0;
for counter=1:numel(input_signal_diff)
    if (abs(input_signal_diff(counter))>(mean_abs_sig_diff+stds_num*std_abs_sig_diff))
        if  (min(abs(ann_indxs-counter))>sample_rate*0.3) && (min(abs(ann_idxs_added-counter))>sample_rate*0.3)
        ann_idxs_added=[ann_idxs_added counter];
        end
    end
end
ann_indxs=sort([ann_indxs ann_idxs_added]);
ann_indxs=ann_indxs(2:end);