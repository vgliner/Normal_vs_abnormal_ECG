function abnormal_amplitude_beats=amplitude_analysis(cleaned_vector,r_vec)
% plot(cleaned_vector)
% hold on
% plot(r_vec,cleaned_vector(r_vec),'xr')

abnormal_amplitude_beats=(sum(cleaned_vector(r_vec)<0.6*mean(cleaned_vector(r_vec)))+sum(cleaned_vector(r_vec)>1.3*mean(cleaned_vector(r_vec))))/numel(r_vec)*100;


