function  [peakInds_out,unreliable_peaks]=my_unique(peakInds,suspected_noisy_indxs)
%% Clean diffs on noisy segments
unreliable_peaks=(ismember(peakInds,suspected_noisy_indxs))+(ismember(peakInds-1,suspected_noisy_indxs))+(ismember(peakInds+1,suspected_noisy_indxs));
unreliable_peaks=(unreliable_peaks>0);
diff_peakInds=diff(peakInds);
[~,b]=find(diff_peakInds<10);
peakInds_out=peakInds;
if numel(b)>0
peakInds_out(b)=[];
unreliable_peaks(b)=[];
end