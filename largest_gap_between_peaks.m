function largest_gap=largest_gap_between_peaks(val,Peakdiffs,Fs,peakInds)
largest_gap=0;
potentially_noisy_indxs_in_vector=noisy_segments_in_vector(val,Fs);
for counter=1:numel(Peakdiffs)
    if (Peakdiffs(counter)/Fs>largest_gap)&&~ismember(peakInds(counter),potentially_noisy_indxs_in_vector)
    largest_gap=Peakdiffs(counter)/Fs;
    end
end

