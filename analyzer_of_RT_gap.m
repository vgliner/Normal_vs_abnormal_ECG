function [mean_RT_gap,std_RT_gap]=analyzer_of_RT_gap(R_peak_indxs,T_peak_indxs,Fs)
R_T_diffs_buff=0;
local_counter=1;
mean_RT_gap=1;
std_RT_gap=0;
for counter=2:numel(R_peak_indxs)
    diffs=T_peak_indxs-R_peak_indxs(counter);
    diffs=diffs(diffs>0);
    if numel(diffs)>0
        R_T_diffs_buff(local_counter)=diffs(1);
        local_counter=local_counter+1;
    end
end

if numel(R_T_diffs_buff)
    mean_RT_gap=mean(R_T_diffs_buff);
    std_RT_gap=std(R_T_diffs_buff);    
end

mean_RT_gap=mean_RT_gap/Fs;
std_RT_gap=std_RT_gap/Fs;

end