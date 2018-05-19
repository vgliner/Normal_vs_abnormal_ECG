function num_of_PVC=PVC_counter_Challenge(RR_Intervals,perc_of_RR,minimal_num_of_peaks)
try
        [N,edges] = histcounts(RR_Intervals,7);
        [~,b]=max(N);
        typical_interval=edges(b);
        PVC_definition=typical_interval*perc_of_RR;
        for counter=1:numel(N)
            if (N(counter)>=minimal_num_of_peaks)
                first_compatible_bin=counter;
                break
            end
        end

        if (edges(first_compatible_bin)<PVC_definition)
            num_of_PVC=N(first_compatible_bin);
        else
            num_of_PVC=0;
        end
catch
    num_of_PVC=0;
end

[~,b]=find(RR_Intervals<perc_of_RR*mean(RR_Intervals));