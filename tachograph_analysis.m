function [max_significant_period,min_significant_period,RR_span,pdca,max_significant_period_no_thresh,hist_gap,max_dist_between_peaks,super_significant_max_period,abnormally_short,normal_deviation,diffs_entropy]=tachograph_analysis(diff_peakInds,Fs,plot_flag)
edges_vec=0:0.1:2;
if plot_flag
subplot(3,2,3)
histogram(diff_peakInds/Fs,edges_vec);
end
%[h1 ,h2]=histcounts(diff_peakInds/Fs);
[h1 ,h2]=histcounts(diff_peakInds/Fs,edges_vec);
b=find(h1>2, 1, 'last' );
super_significant_max_period=find(h1>3, 1, 'last' );
if numel(super_significant_max_period)
   super_significant_max_period= h2(super_significant_max_period);
else
    super_significant_max_period= 0;
end
if numel(b)>0
    max_significant_period=h2(b+1);
else
    max_significant_period=0.8;
end

b=find(h1>2, 1 ,'first');
if numel(b)>0
    min_significant_period=h2(b);
else
    min_significant_period=0.7;
end
RR_span=max_significant_period- min_significant_period;

[pdca] = fitdist(diff_peakInds'/Fs,'Normal');

b=find(h1>0,1,'last');
if numel(b)>0
    max_significant_period_no_thresh=h2(b+1);
else
    max_significant_period_no_thresh=0.8;
end

%%  Maximum gap in histogram

b1=find(h1>2, 1 ,'first');
if numel(b1)==0
b1=find(h1>0, 1 ,'first');    
end

b2=find(h1>2, 1 ,'last');
if numel(b2)==0
b2=find(h1>0, 1 ,'last');    
end
b3=find(h1==0);
zero_gaps=find((b3>b1)+(b3<b2));
if numel(zero_gaps)
    hist_gap=sum(zero_gaps)*(h2(2)-h2(1));
else
    hist_gap=0;
end


%% Max distance between peaks
[q1,q2]=sort(h1);
try
max_dist_between_peaks=abs(max([q2(end)-q2(end-1), q2(end)-q2(end-2)])*(h2(2)-h2(1)));
catch
 max_dist_between_peaks=0;   
end
if plot_flag
    title(['Max. Period: ' num2str(max_significant_period) ' Min. Period: ' num2str(min_significant_period) ' Span: ' num2str(RR_span) ' Gap: ' num2str(hist_gap) 'Between peaks: ' num2str(max_dist_between_peaks)]);
end    

%%  Additional Tachograph analysis
mean_diff_peaks=mean(diff_peakInds);
abnormally_short=numel(find(diff_peakInds<0.85*mean_diff_peaks))/numel(diff_peakInds);
normal_deviation=numel(find((diff_peakInds<1.1*mean_diff_peaks).*(diff_peakInds>0.9*mean_diff_peaks)))/numel(diff_peakInds);
diffs_entropy = wentropy(diff_peakInds,'shannon');


%% More solid maximum gap