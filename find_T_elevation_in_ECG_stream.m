function max_corr=find_T_elevation_in_ECG_stream(ECG,r_peaks,pattern,polarity)

max_corr=0;
for counter=1:numel(r_peaks)
    try
        x=ECG(r_peaks(counter)-10:r_peaks(counter)+150);
        current_correlation=xcov(polarity*x,pattern,'coeff');
        current_correlation=current_correlation(161);
        max_corr=max(max_corr,current_correlation);
    catch
        
    end
end