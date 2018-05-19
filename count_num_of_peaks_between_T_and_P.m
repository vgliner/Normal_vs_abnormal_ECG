function average_num_of_peaks=count_num_of_peaks_between_T_and_P(ECG_vec,P_vec,T_vec)
counter=0;
num_of_peaks=0;

for indx_counter=1:numel(T_vec)
       p_indx= find(P_vec>T_vec(indx_counter),1,'first');
       try
           sample=ECG_vec(T_vec(indx_counter):P_vec(p_indx));
           peaks_found=peakfinder1(sample,(max(sample)-min(sample))/10);
           num_of_peaks=num_of_peaks+numel(peaks_found);
           counter=counter+1;
       catch
           
       end    
end
try
average_num_of_peaks=num_of_peaks/counter;
catch
average_num_of_peaks=0;    
end
