function [num_of_neg_beats, perc_of_neg_beats]=count_negative_beats(r_vec,cleaned_vector,polarity,plot_flag)
try
        if polarity>0

           mean_amp= mean(cleaned_vector(r_vec(find(cleaned_vector(r_vec)>0))));
            neg_indxs=find(cleaned_vector(r_vec)<-0.6*mean_amp);
            num_of_neg_beats=numel(neg_indxs);
            perc_of_neg_beats=num_of_neg_beats/numel(r_vec)*100;
        else
           mean_amp= mean(cleaned_vector(r_vec(find(cleaned_vector(r_vec)<0))));
            neg_indxs=find(cleaned_vector(r_vec)>-0.6*mean_amp);
            num_of_neg_beats=numel(neg_indxs);
            perc_of_neg_beats=num_of_neg_beats/numel(r_vec)*100;
        end
catch
    num_of_neg_beats=0;
    perc_of_neg_beats=0;
end

if plot_flag
    subplot(3,2,5)
    hold on
    xlabel(['Num. of neg. beats : ' num2str(num_of_neg_beats)]);
    hold off    
end