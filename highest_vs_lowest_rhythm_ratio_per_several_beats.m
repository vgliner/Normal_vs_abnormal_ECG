function [rhythm_ratio_short_segment,highest_rhythm,lowest_rhythm]=highest_vs_lowest_rhythm_ratio_per_several_beats(t,PeakInds,Fs,potentially_noisy_indxs_in_vector)
rhythm_ratio_short_segment=1;
num_of_beats_per_segment=6;
highest_rhythm=0;
lowest_rhythm=10000;
if (numel(PeakInds)>num_of_beats_per_segment)
    for counter=1:(numel(PeakInds)-num_of_beats_per_segment)
        if ismember(PeakInds(counter),potentially_noisy_indxs_in_vector)
            continue
        end
        segment_rhythm=(num_of_beats_per_segment-1)/(t(PeakInds(counter+num_of_beats_per_segment-1))-t(PeakInds(counter)))*60; % BPM
        if segment_rhythm>highest_rhythm
            highest_rhythm=segment_rhythm;
        end
        if segment_rhythm<lowest_rhythm
        lowest_rhythm=segment_rhythm;
        end        
    end
    rhythm_ratio_short_segment=highest_rhythm/lowest_rhythm;
end