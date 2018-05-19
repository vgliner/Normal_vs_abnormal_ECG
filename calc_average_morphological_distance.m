function [morphological_distance,suspected_neg_beats,max_distance_between_morphologically_good_peaks]=calc_average_morphological_distance(val,average_beat_vec,peakInds,potentially_noisy_indxs_in_vector,polarity,Fs)
morphological_distance=0;
valid_peak_counter=0;
suspected_neg_beats=0;
last_valid_peak=1;
max_distance_between_morphologically_good_peaks=0;
for counter=1:numel(peakInds)
    try
        if ~ismember(peakInds(counter),potentially_noisy_indxs_in_vector)
            signal_to_inspect=val(peakInds(counter)-25:peakInds(counter)+25);
            dist=dtw(polarity*signal_to_inspect/(max(signal_to_inspect)-min(signal_to_inspect)),  average_beat_vec(ceil(numel(average_beat_vec)/2)-25:floor(numel(average_beat_vec)/2)+25),'squared');
            dist_neg=dtw(-polarity*signal_to_inspect/(max(signal_to_inspect)-min(signal_to_inspect)),  average_beat_vec(ceil(numel(average_beat_vec)/2)-25:floor(numel(average_beat_vec)/2)+25),'squared');
            if dist_neg<0.5*dist
                suspected_neg_beats=suspected_neg_beats+1;
            end
            morphological_distance=morphological_distance+dist;
            valid_peak_counter=valid_peak_counter+1;
            if dist<3
                if (peakInds(counter)-last_valid_peak)>max_distance_between_morphologically_good_peaks
                max_distance_between_morphologically_good_peaks=peakInds(counter)-last_valid_peak;
                end
                last_valid_peak=peakInds(counter);
            end
        else
            last_valid_peak=peakInds(counter);
        end
    catch
        
    end
end
morphological_distance=morphological_distance/valid_peak_counter;
max_distance_between_morphologically_good_peaks=max_distance_between_morphologically_good_peaks/Fs;