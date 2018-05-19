function [data_for_log]=segment_classifier(ECG_vec,sample_rate,plot_flag,counter,Record_name,Type,general_log_counter,full_record_name,correlation_template,others_template,T_elevation_template)
            data_for_log=[];
            T = 1/sample_rate;             % Sampling period
            Fs=sample_rate;
            vec=ECG_vec; 
% %            % vec=sgolayfilt(vec,3,5);
%             cleaned_ecg_vec=clean_significant_noisy_part_of_long_record(vec);
%             vec=cleaned_ecg_vec; 
            [cleaned_vector, spectrogram_output,suspected_noisy_indxs,Thresh]=significant_noise_peak_detector_misleader_cleaner2(vec,100,3.2); %3.2
%             %% Imperfect gap cleaning
%             if mod(general_log_counter,2)
%                     try
%                     vec=medfilt1(diff(cleaned_vector));
%                    % temp_peaks=findpeaks(vec)
%                     val=spectrogram_cleaner(cleaned_vector,vec);     
%                     L = numel(vec);             % Length of signal
%                     t = (0:L-1)*T;        % Time vector
%                        try
%                         peakInds=my_peak_detector_one_function(abs(hilbert(vec)),360,t,1);
%                         catch
%                         peakInds=my_peak_detector_one_function(val,360,t,0);                
%                         end
% 
%                     a=find(peakInds>suspected_noisy_indxs(1));
%                     b=find(peakInds<suspected_noisy_indxs(1));
%                     additional_cleaning_indxs=peakInds(b(end)):peakInds(a(1));            
%                     cleaned_vector(additional_cleaning_indxs)=[];                                                
%                     catch
% 
%                     end
%             end
            %%
            data_for_log=[data_for_log numel(suspected_noisy_indxs)/numel(vec)];
            vec=medfilt1(diff(cleaned_vector));
           % temp_peaks=findpeaks(vec)
            val=spectrogram_cleaner(cleaned_vector,vec);     
            L = numel(vec);             % Length of signal
            t = (0:L-1)*T;        % Time vector
            [spectrogram_noise_info,lobs_mean_area,lobs_area_std,centroid_mean,centroid_std]=spectrogram_image_processing(abs(spectrogram_output),t(end));
          if sum(isnan(spectrogram_noise_info))
              spectrogram_noise_info(1)=0.078;
              spectrogram_noise_info(2)=1.72;
          end
          data_for_log= [data_for_log spectrogram_noise_info];
                try
                    peakInds=my_peak_detector_one_function( abs(hilbert(vec)),300,t,1);                    
                catch
                    peakInds=my_peak_detector_one_function(val,300,t,0);
                end
             number_of_negative_PVC=count_negative_PVCs(cleaned_vector,peakInds);
            if (numel(peakInds)<5)&&(numel(peakInds>0))%% Significant spike which misleading the peak detector
                for mini_counter=1:numel(peakInds)
                        val(max(1,peakInds(mini_counter)-150):min(numel(val),peakInds(mini_counter)+150))=mean(val(max(1,peakInds(mini_counter)-150):min(numel(val),peakInds(mini_counter)+150)));
                end
                try
                peakInds=my_peak_detector_one_function(abs(hilbert(vec)),360,t,1);
                catch
                peakInds=my_peak_detector_one_function(val,360,t,0);                
                end

            end
            [peakInds,unreliable_peaks]=my_unique(peakInds,suspected_noisy_indxs);
            %data_for_log=[data_for_log sum(unreliable_peaks)/numel(peakInds)];
            diff_peakInds=diff(peakInds);    
            if (sum(unreliable_peaks(1:end-1))>0)
               diff_peakInds(unreliable_peaks(1:end-1))=[];
            end
            annotations_per_time=numel(peakInds)/t(end);            
            try
                if ~isrow(val)
                    val=val';
                end
           if peakInds(1)<5
               peakInds(1)=[];
           end
            tends = twaveend(val, 300, peakInds)';  % End of T waves
            fibrillations_num_vec=find_num_of_fibrillations(val,peakInds, tends); % Fibrillations counter
            data_for_log=[data_for_log numel(fibrillations_num_vec)/numel(peakInds)];
            fibrillation_noise_flag=0;
            catch
            fibrillation_noise_flag=1;    
            fibrillations_num_vec=0;
            end
            if plot_flag
            subplot(3,2,1)
            plot(t,vec)
            title('Signal Derivative');
            subplot(3,2,2)
            L1 = numel(ECG_vec);             % Length of signal
            t1 = (0:L1-1)*T;        % Time vector            
            plot(t1,ECG_vec)
            title_str=['Record ' num2str(Record_name(counter)) ' ' Type(counter) ' Original'];
            title(title_str);
            hold on
            my_mask(1:numel(ECG_vec))=0;
                if numel(suspected_noisy_indxs)
                    my_mask(suspected_noisy_indxs)=1;
                    plot(t1,my_mask)
                end
            hold off
            end
            Y = fft(vec);
            P2 = abs(Y/L);
            P1 = P2(1:floor(L/2)+1);
            P1(2:end-1) = 2*P1(2:end-1);    
            f = Fs*(0:(L/2))/L;
            if plot_flag    
            subplot(3,2,3)
            end     
        %% Entropy
         maxScale=6;
         %vec_to_entropy=ECG_vec;
         vec_to_entropy=cleaned_vector;
         if isrow(vec_to_entropy)
             vec_to_entropy=vec_to_entropy';
         end
        [entropyNoise,scale1]=msentropy(vec_to_entropy,[],[],[],[],[],[],[],maxScale);
        data_for_log=[data_for_log entropyNoise'];
        y = hilbert(vec);
       % [Pxx,F]=lomb([t(peakInds)' val(peakInds)']);
         num_of_PVC=PVC_counter_Challenge(diff_peakInds,0.7,2);
         data_for_log=[data_for_log num_of_PVC num_of_PVC/numel(peakInds)];
        if plot_flag
        plot(spectrogram_output(end,:))
        hold on
        plot(smooth(spectrogram_output(end,:)))        
        v1=[];
        v1(1:numel(spectrogram_output(end,:)))=Thresh;
        plot(v1,'r')
        plot(3*v1,'k')     
        title('Spectrogram')
        hold off
        end        
        [C,I] = max(spectrogram_output(:));
       % data_for_log=[data_for_log C];        
        if ~(isrow(diff_peakInds))
            diff_peakInds=diff_peakInds';
        end
        ibi=[ t(peakInds(1:numel(diff_peakInds)))' diff_peakInds'/Fs];        
        output=poincareHRV(ibi);
        if sum(isnan([output.SD1 output.SD2]))
            output.SD1=100;
            output.SD2=100;
        end
        data_for_log=[data_for_log abs(output.SD1)  abs(output.SD2) ];
        if plot_flag
         subplot(3,2,4)  
        plot(abs(y));
        hold all
        end
            vec2=abs(y);
            Low_freq_energy_vs_high=sum(P1(f<10))./sum(P1(f>=10));
            HRV_std_vs_mean=std(diff_peakInds)/mean(diff_peakInds);
            HR=numel(peakInds)/(t(peakInds(end))-t(peakInds(1)))*60;
            PVC_factor=(min(diff_peakInds)/mean(diff_peakInds));
            data_for_log=[data_for_log Low_freq_energy_vs_high HRV_std_vs_mean HR  PVC_factor std(diff_peakInds)];        
            if (numel(PVC_factor)==0)
                PVC_factor=0;
            end
            [is_AFIB_suspect, missing_beats]=AFIB_Detector_based_on_missing_beats(diff_peakInds,HR,Fs);            
            data_for_log=[data_for_log missing_beats];
           bw = imbinarize(abs(spectrogram_output));
            E = entropy(bw);
%             glcm = graycomatrix(bw);
%              stats = graycoprops(glcm)
%              J = dct2(bw);
            if plot_flag    
            plot(peakInds,vec2(peakInds),'x')
            title(['Hilbert Transform, HRV_std/mean:   '  num2str(HRV_std_vs_mean), '  HR:' num2str(HR) ' PVC: ' num2str(num_of_PVC) 'Beats num:' num2str(numel(peakInds))])           
            hold off
             subplot(3,2,5)   
           %%  Test T wave detector
           plot(t,cleaned_vector(1:end-1))
              hold all
              plot(t(peakInds),val(peakInds),'ro')
             plot(t(tends),val(tends),'xk')
              hold off
            subplot(3,2,6)               
%             surf(spectrogram_output);
%             view(90, 0);
            imagesc(abs(spectrogram_output))
            colormap jet
   
            title(['Entropy  ' num2str(E),'Entropy normalized     '  num2str(E/numel(peakInds))]);

            %%  My  Classification
            subplot(3,2,1)
            end
              %%  Classify to normal
            data_for_log=[data_for_log annotations_per_time];
             largest_gap=largest_gap_between_peaks(val,diff_peakInds,Fs,peakInds);
             data_for_log=[data_for_log largest_gap/HR*60];
              [mean_RT_gap,std_RT_gap]=analyzer_of_RT_gap(peakInds,tends,Fs);
              data_for_log=[data_for_log mean_RT_gap std_RT_gap];  
            data_for_log=[data_for_log number_of_negative_PVC];
            [number_of_enlarged_T_waves,indxs_of_enlarged_T_waves,potentially_noisy_indxs_in_vector]=count_enlarged_T_waves(val,peakInds,Fs);            
            data_for_log=[data_for_log number_of_enlarged_T_waves];
            [rhythm_ratio_short_segment,highest_rhythm,lowest_rhythm]=highest_vs_lowest_rhythm_ratio_per_several_beats(t,peakInds,Fs,potentially_noisy_indxs_in_vector);
            data_for_log=[data_for_log rhythm_ratio_short_segment highest_rhythm lowest_rhythm];
            data_for_log=[data_for_log  lobs_mean_area,lobs_area_std,centroid_mean,centroid_std];
            % Wavelet decomposition
            [stdevs_vec]=wavelets_analysis(val,Fs) ;          
            data_for_log=[data_for_log stdevs_vec];
            data_for_log=[data_for_log (abs(output.SD1)/abs(output.SD2))];
            [pLF,pHF,LFHFratio,VLF,LF,HF,f,Y,NFFT] = fft_val_fun(diff_peakInds,Fs);   
            if isnan(LFHFratio)
                LFHFratio=1.358;
            end
            data_for_log=[data_for_log LFHFratio];            
            [average_beat_vec, polarity,correlation_factor,min_correlation_factor]=extract_average_beat_vector(val,peakInds,HR,Fs,potentially_noisy_indxs_in_vector,plot_flag);
             [QS_width,rmse_p,rmse_t,morphological_distance,suspected_neg_beats,max_distance_between_morphologically_good_peaks,T_R_ratio,T_P_ratio,RS_slope,QR_RS_slope_ratio,t_wave_a,QR_Morphology_change,RS_Morphology_change,u_tp_ratio,sigma_tp_ratio,bundle_block_suspect,Q_level,S_level,cross_corr,min_der_ST_segment,others_cross_corr,others_cross_corr2,S_R_ratio]=beat_morphology_analysis(average_beat_vec,val,peakInds,Fs,polarity,potentially_noisy_indxs_in_vector,plot_flag,correlation_template,others_template);
            data_for_log=[data_for_log QS_width rmse_p rmse_t,morphological_distance,suspected_neg_beats,max_distance_between_morphologically_good_peaks,T_R_ratio,T_P_ratio,RS_slope];
            data_for_log=[data_for_log correlation_factor min_correlation_factor];
            [max_significant_period,min_significant_period,RR_span,pdca,max_significant_period_no_thresh,hist_gap,max_dist_between_peaks,super_significant_max_period,abnormally_short,normal_deviation,diffs_entropy_shannon]=tachograph_analysis(diff_peakInds,Fs,plot_flag);
            data_for_log=[data_for_log max_significant_period min_significant_period RR_span pdca.mu pdca.sigma,max_significant_period_no_thresh,hist_gap];
            data_for_log=[data_for_log E max_dist_between_peaks super_significant_max_period QR_RS_slope_ratio numel(peakInds) E/numel(peakInds) t_wave_a]; % Image Entropy
            [abnormal_peaks_num,~]=wavelet_finder_of_strange_peaks(val,peakInds,0);
            data_for_log=[data_for_log abnormal_peaks_num abnormal_peaks_num/numel(peakInds)];
     
            
            [q_vec,r_vec,s_vec,t_vec,p_vec,max_corr_T]=beats_morphology_analyzer(val,peakInds,HR,Fs,potentially_noisy_indxs_in_vector,y,T_elevation_template,plot_flag);
           correlation_grade=correlation_analyzer(cleaned_vector,q_vec,r_vec,s_vec,t_vec,p_vec);
            [mean_qrs_width,std_qrs_width,mean_st_width,std_st_width,mean_pr_width,std_pr_width,entropyNoise]=  beats_morphology_analyzer_satistics(q_vec,r_vec,s_vec,t_vec,p_vec,Fs);
            data_for_log=[data_for_log mean_qrs_width,std_qrs_width,mean_st_width,std_st_width,mean_pr_width,std_pr_width,entropyNoise,abs(output.SD1./output.SD2)];
            abnormal_amplitude_beats=amplitude_analysis(cleaned_vector,r_vec);
        if plot_flag
            subplot(3,2,5)               
            hold on
            plot(t(r_vec),cleaned_vector(r_vec),'ko')
            plot(t(s_vec),cleaned_vector(s_vec),'k*')
            plot(t(q_vec),cleaned_vector(q_vec),'m*')
            plot(t(t_vec),cleaned_vector(t_vec),'c*')
            plot(t(p_vec),cleaned_vector(p_vec),'g*')
            title(['Av. qrs width: ' num2str(mean_qrs_width) ' ,std. qrs width: ' num2str(std_qrs_width)] )
            hold off
            subplot(3,2,2)
        end
        snr_cleaned_vector=snr(cleaned_vector,Fs);
        data_for_log=[data_for_log abnormally_short normal_deviation abnormal_amplitude_beats snr_cleaned_vector];
        sfdr_result = sfdr(cleaned_vector,Fs);
        thd_result=thd(cleaned_vector,Fs);
        correlation_outliers_perc=cross_correlation_analyzer(cleaned_vector,r_vec,average_beat_vec,Fs);        
        data_for_log=[data_for_log sfdr_result thd_result  diffs_entropy_shannon correlation_outliers_perc QR_Morphology_change RS_Morphology_change];
        if isrow(cleaned_vector)
            cleaned_vector=cleaned_vector';
        end
        auto_regression = getarfeat(cleaned_vector,2);
        data_for_log=[data_for_log auto_regression SampEn(diff_peakInds,1,1)];
        [mean_peaks_per_segment, std_peaks_per_segment,entropy_of_peaks_per_segment]=mean_peaks_in_RR_interval(cleaned_vector,r_vec); 
        data_for_log=[data_for_log  mean_peaks_per_segment std_peaks_per_segment entropy_of_peaks_per_segment];
        most_dominant_freq=calc_most_dominant_freq(cleaned_vector,Fs);
        data_for_log=[data_for_log  most_dominant_freq u_tp_ratio sigma_tp_ratio];
        pNN50=calculate_pNN50(r_vec,Fs);
        data_for_log=[data_for_log pNN50 correlation_grade];
        st_elevation=calculate_average_st_elevation(cleaned_vector, q_vec,r_vec,s_vec);
        data_for_log=[data_for_log st_elevation bundle_block_suspect Q_level S_level cross_corr];
        [num_of_neg_beats, perc_of_neg_beats]=count_negative_beats(r_vec,cleaned_vector,polarity,plot_flag);
        raw_sig_energy_density=sum(abs(ECG_vec))/numel(ECG_vec);
        if plot_flag
                subplot(3,2,6)
                hold on
                xlabel(num2str(raw_sig_energy_density))
                hold off
        end
        average_num_of_peaks=count_num_of_peaks_between_T_and_P(cleaned_vector,p_vec,t_vec);
        data_for_log=[data_for_log num_of_neg_beats perc_of_neg_beats min_der_ST_segment others_cross_corr raw_sig_energy_density average_num_of_peaks others_cross_corr2];
        AA=abs(spectrogram(diff(cleaned_vector),100));
        siz1=size(AA);
         bw = imbinarize(abs(AA));
         E_cleaned = entropy(bw);
         data_for_log=[data_for_log E_cleaned E_cleaned/siz1(2) E_cleaned/numel(peakInds) S_R_ratio max_corr_T];
        