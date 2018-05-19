function [q_vec,r_vec,s_vec,t_vec,p_vec,bundle_block_peak,max_corr]=beats_morphology_analyzer(val,peakInds,HR,Fs,potentially_noisy_indxs_in_vector,hilbert_result,T_elevation_template,plot_flag)
bundle_block_peak=[];      
half_window=ceil(Fs/(HR/60)/2*0.9);
half_window_qrs=ceil(Fs/(HR/60)/2*0.7);

failed_to_process=0;
 [reaaranged_indxs,polarity_counter]=reaarrange_peak_Inds(val,peakInds);
 peakInds=reaaranged_indxs;
 p_vec=[];
 q_vec=[];
 r_vec=[];
 s_vec=[];
 t_vec=[];
 
%  figure
%  plot(beat_vet)
val=val*polarity_counter;
normal_beat_cntr=1;
hilbert_result=abs(hilbert_result);
for cntr=1:numel(peakInds)
    try
                Lia = ismember(peakInds(cntr)-half_window:peakInds(cntr)+half_window,potentially_noisy_indxs_in_vector);
        %         if sum(Lia)>0
        %             failed_to_process=failed_to_process+1;            
        %             continue
        %         end
            [a,b]=max(hilbert_result(peakInds(cntr)-half_window_qrs:peakInds(cntr)+half_window_qrs));
            % Find R index    
             r_indx=b+peakInds(cntr)-half_window_qrs-3;
             if r_indx<1
                 continue         
             end
            r_vec=[r_vec r_indx]; 
            % Find S index
             s_indx=r_indx+10;   
           while(val(s_indx)>val(s_indx+1))
               s_indx=s_indx+1;
           end     
            s_vec=[s_vec s_indx];   
            % Find Q index    
           q_indx=r_indx-3;
           while(val(q_indx)>val(q_indx-1))
               q_indx=q_indx-1;
           end
            q_vec=[q_vec q_indx];   
            % Find T index            
            [~,b]=max(val(s_indx+5:min([s_indx+75 numel(val)])));
            t_indx=s_indx+b;
            t_vec=[t_vec t_indx];    
            % Find P index            
            [a,b]=max(smooth(val(max([q_indx-75 1]):q_indx)));
            p_indx=b+max([q_indx-75 1]);
            p_vec=[p_vec p_indx];                
    catch
        failed_to_process=failed_to_process+1;
    continue
    end
    normal_beat_cntr=normal_beat_cntr+1;
end

if plot_flag
subplot(3,2,2)
end
max_corr=find_T_elevation_in_ECG_stream(val,r_vec,T_elevation_template,polarity_counter);