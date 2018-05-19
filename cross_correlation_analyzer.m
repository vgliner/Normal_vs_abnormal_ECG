function correlation_outliers_perc=cross_correlation_analyzer(cleaned_vector,r_vec,average_beat_vec,Fs)
beat_vec_length=numel(average_beat_vec);
for counter=1:numel(r_vec)
    current_beat_vec=cleaned_vector(max(1,r_vec(counter)-floor(beat_vec_length/2)):min(numel(cleaned_vector),r_vec(counter)+floor(beat_vec_length/2)));
    auclidean_dist(counter)=dtw(current_beat_vec,average_beat_vec);
end
mean_aucledian_dist=mean(auclidean_dist);
std_aucledian_dist=std(auclidean_dist);
correlation_outliers_perc=numel(find(auclidean_dist>mean_aucledian_dist+3*std_aucledian_dist))/numel(r_vec)*100;
