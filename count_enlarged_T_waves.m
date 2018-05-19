function [number_of_enlarged_T_waves,indxs_of_enlarged_T_waves,potentially_noisy_indxs_in_vector]=count_enlarged_T_waves(vec,peakInds,Fs)
number_of_enlarged_T_waves=0;
indxs_of_enlarged_T_waves=[];
potentially_noisy_indxs_in_vector=noisy_segments_in_vector(vec,Fs);

%%  Determine polarity
mean_peaks=mean(vec(peakInds));
percentage_of_shift=0.1;
if numel(peakInds)>3
    for counter=1:numel(peakInds)-1
        diff_peak=peakInds(counter+1)-peakInds(counter);
        if mean_peaks>0  % Positive polarity
                    try 
                        [a,b]=max(vec(round(peakInds(counter)+percentage_of_shift*diff_peak):round(peakInds(counter+1)-percentage_of_shift*diff_peak)));
                        if (a>0.7*mean([vec(peakInds(counter)) vec(peakInds(counter+1))]))&&~ismember(peakInds(counter),potentially_noisy_indxs_in_vector)
                            indxs_of_enlarged_T_waves=[indxs_of_enlarged_T_waves peakInds(counter)+b];
                            number_of_enlarged_T_waves=number_of_enlarged_T_waves+1;
                        end
                    catch
                        
                    end
        else   % Negative polarity
                    try 
                        [a,b]=min(vec(round(peakInds(counter)+percentage_of_shift*diff_peak):round(peakInds(counter+1)-percentage_of_shift*diff_peak)));
                        if (a<0.7*mean([vec(peakInds(counter)) vec(peakInds(counter+1))]))&&~ismember(peakInds(counter),potentially_noisy_indxs_in_vector)
                            indxs_of_enlarged_T_waves=[indxs_of_enlarged_T_waves peakInds(counter)+b];
                            number_of_enlarged_T_waves=number_of_enlarged_T_waves+1;                            
                        end
                    catch
                        
                    end
        end    
   end    
end
