function [is_AFIB_suspect, missing_beats]=AFIB_Detector_based_on_missing_beats(diff_peakInds,HR,sample_rate)

typical_diff_between_peaks=60/HR;
[a,b]=find(diff_peakInds>1.25*typical_diff_between_peaks*sample_rate);
missing_beats=numel(b);
threshold=2/75;
is_AFIB_suspect=(missing_beats/numel(diff_peakInds)>threshold);
is_AFIB_suspect=(is_AFIB_suspect) && (missing_beats>1);

