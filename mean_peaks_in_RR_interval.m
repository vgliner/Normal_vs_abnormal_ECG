function [mean_peaks_per_segment, std_peaks_per_segment,entropy_of_peaks_per_segment]=mean_peaks_in_RR_interval(cleaned_vector,r_vec)

for counter=2:numel(r_vec)
    num_of_maximas_per_segment(counter-1)=numel(extrema(cleaned_vector(r_vec(counter-1):r_vec(counter))));
end
mean_peaks_per_segment=mean(num_of_maximas_per_segment)/2;
std_peaks_per_segment=std(num_of_maximas_per_segment)/sqrt(2);
if iscolumn(num_of_maximas_per_segment)
    num_of_maximas_per_segment=num_of_maximas_per_segment';
end
entropy_of_peaks_per_segment=SampEn(num_of_maximas_per_segment,1,1);