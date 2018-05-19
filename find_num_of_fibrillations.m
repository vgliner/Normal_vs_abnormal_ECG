function fibrillations_num_vec=find_num_of_fibrillations(ECG_vec,R_peaks_indxs, T_wave_ends_indxs)
fibrillations_num_vec=[];
R_indxs_counter=1;
for counter=1:numel(T_wave_ends_indxs)
   diffs= R_peaks_indxs-T_wave_ends_indxs(counter);
   try
   next_R_peak=min(diffs(diffs>0));
   catch
       break
   end
   vec_for_analysis=ECG_vec(    T_wave_ends_indxs(counter)  :   (T_wave_ends_indxs(counter)+next_R_peak-10)    );
   [xmax,imax,xmin,imin] = extrema(vec_for_analysis);
   fibrillations_num_vec(counter)=numel(imin);
end

% 
% plot(vec_for_analysis)
% hold all
% plot(imax,vec_for_analysis(imax),'xr')
% plot(imin,vec_for_analysis(imin),'or')
