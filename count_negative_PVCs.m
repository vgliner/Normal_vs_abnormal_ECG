function number_of_negative_PVC=count_negative_PVCs(ECG_vec,peakInds)
number_of_negative_PVC=0;
if numel(peakInds)<3
    return
end
counter=2;
%% Find average QRS morphology
width=30;
while  (counter<numel(peakInds))
    signal_1=ECG_vec(max(1,peakInds(counter)-width):min(numel(ECG_vec),peakInds(counter)+width));% Extract first QRS complex
    signal_2=ECG_vec(max(1,peakInds(counter-1)-width):min(numel(ECG_vec),peakInds(counter-1)+width)); % Extract second QRS complex    
%     dtw(signal_1,signal_2);
%     hold on
%     waitforbuttonpress    
%     dtw(signal_1,-signal_2);
%     hold off
%     eucl_dist_pos=dtw(signal_1,signal_2);
%     eucl_dist_neg=dtw(signal_1,-signal_2);    
%     signal_1_norm=linmap(signal_1,[0 1]);
%     signal_2_norm=linmap(signal_2,[0 1]);
%      eucl_dist_pos=dtw(signal_1_norm,signal_2_norm);
     signal_1=signal_1-mean(signal_1);
     signal_2=signal_2-mean(signal_2);     
     cb = xcorr(diff(signal_1),diff(signal_2),'none');     
    [~,b]=max(abs(cb));
    [~,c]=max(cb);
    [~,d]=min(cb);

    a=cb(b);
    if a<0
        if abs(cb(d))>1.15*abs(cb(c))
       counter=counter+1;
       number_of_negative_PVC=number_of_negative_PVC+1;        
        end
    end
       counter=counter+1;    
%     if eucl_dist_neg<eucl_dist_pos
%         number_of_negative_PVC=number_of_negative_PVC+1;
%         counter=counter+1;
%     end
end
