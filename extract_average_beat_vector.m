function [average_beat_vec,polarity,correlation_factor,min_correlation_factor]=extract_average_beat_vector(val,peakInds,HR,Fs,potentially_noisy_indxs_in_vector,plot_flag)
polarity=1;
half_window=ceil(Fs/(HR/60)/2*0.9);
beat_vet(1:half_window*2+1)=0;
failed_to_average=0;
 [reaaranged_indxs,polarity_counter]=reaarrange_peak_Inds(val,peakInds);
 peakInds=reaaranged_indxs;
%  figure
%  plot(beat_vet)
for cntr=1:numel(peakInds)
    try
        Lia = ismember(peakInds(cntr)-half_window:peakInds(cntr)+half_window,potentially_noisy_indxs_in_vector);
        if sum(Lia)>0
            failed_to_average=failed_to_average+1;            
            continue
        end
        beat_vet=beat_vet+detrend(val(peakInds(cntr)-half_window:peakInds(cntr)+half_window));  
%         hold on
%         plot(val(peakInds(cntr)-half_window:peakInds(cntr)+half_window))
%         waitforbuttonpress
    catch
        failed_to_average=failed_to_average+1;
    continue
    end
end
beat_vet=beat_vet/(cntr-failed_to_average);
beat_vec=detrend(beat_vet);
if polarity_counter<0
        beat_vec=-beat_vec;
        polarity=-1;
end
average_beat_vec=beat_vec;
%%  Normalization
average_beat_vec=average_beat_vec/(max(average_beat_vec)-min(average_beat_vec));

if plot_flag
plot(average_beat_vec,'LineWidth',3)
end


%%  Analyze correlation
for counter=1:numel(peakInds)
    try
    A = corrcoef(average_beat_vec,detrend(val(peakInds(counter)-half_window:peakInds(counter)+half_window)));
    dist(counter)=A(1,2);
    catch
    end
end
dist(isnan(dist))=[];
correlation_factor=mean(dist);
min_correlation_factor=min(dist);


%%  Correlator with all beats 13/05/2017
% figure
% for counter=1:numel(peakInds)
%      beat_vet=detrend(val(peakInds(counter)-half_window:peakInds(counter)+half_window));  
%     plot(tansig(beat_vet))
%     hold off
%     waitforbuttonpress
% end
