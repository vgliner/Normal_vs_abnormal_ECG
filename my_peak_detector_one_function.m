function peakInds=my_peak_detector_one_function(vec,sample_rate,t,if_hilbert)

            handles.if_hilbert=if_hilbert;
            %polynomial_degree=34;            
            processed_signal=vec;%ECG_highpass(vec,15,sample_rate,polynomial_degree,5); 
            peakInds=peakfinder(processed_signal,sample_rate,handles,if_hilbert);  
            peakInds=peakInds';
                if numel(peakInds)>5
                ann_indxs=complementary_finder(t,processed_signal,sample_rate,peakInds);  
%                 ann_indxs=PVC_Detector(t,processed_signal,sample_rate,ann_indxs);
%                 ann_indxs=PVC_Detector(t,processed_signal,sample_rate,ann_indxs);             
                %ann_indxs=Ann_cleaner(t,processed_signal,2,ann_indxs);
                if ~isrow(ann_indxs)
                   ann_indxs=ann_indxs';
                end
                ann_indxs=Ann_completer(t,processed_signal,sample_rate,ann_indxs,1.9);    %doing false positives!!!                     
                ann_indxs=Additional_ann_cleaner_no_close_peaks(t,processed_signal,sample_rate,ann_indxs,0.8);
                peakInds=ann_indxs;
                end
end