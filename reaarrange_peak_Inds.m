function [reaaranged_indxs,polarity_counter]=reaarrange_peak_Inds(val,PeakInxs)
%%  Define polarity
polarity_counter=0;
for counter=1:numel(PeakInxs)
    try
        qrsEx = detrend(val(PeakInxs(counter)-50:PeakInxs(counter)+50));     
        [max_qrsEx,max_qrsEx_indx]=max(qrsEx(25:end)); %Maxima
        [min_qrsEx,min_qrsEx_indx]=min(qrsEx);  % Minima
        [a_abs,b_abs]=max(abs(qrsEx));      % Absolute Extrema
        [a,b]=max(qrsEx);        
        if (min_qrsEx_indx<max_qrsEx_indx+25)&&(abs(min_qrsEx)>0.7*a_abs)
            polarity_counter=polarity_counter-1;
        elseif  (max(qrsEx)==max(abs(qrsEx))) 
            polarity_counter=polarity_counter+1;                            
        else
            if (b_abs<b)|| (a_abs>2*a)
            polarity_counter=polarity_counter-1;
            else
            polarity_counter=polarity_counter+1;                
            end            
        end

    catch
        
    end
end
if polarity_counter>=0
polarity_counter=1;
else
polarity_counter=-1; 
val=-val;
end
%%    Rearrangement
for counter=1:numel(PeakInxs)
    try
        [~,b]=max(val(PeakInxs(counter)-50:PeakInxs(counter)+50));
        reaaranged_indxs(counter)=PeakInxs(counter)+b-51;
    catch
        reaaranged_indxs(counter)=PeakInxs(counter);
    end
end
