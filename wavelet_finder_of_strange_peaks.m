function [abnormal_peaks_num,abnormal_peaks_inxs]=wavelet_finder_of_strange_peaks(ecg_vec,ann_vec,plot_flag)
abnormal_peaks_num=0;
abnormal_peaks_inxs=[];
qrsEx=ecg_vec;
wt = modwt(qrsEx,5);
wtrec = zeros(size(wt));
wtrec(4:5,:) = wt(4:5,:);
y = imodwt(wtrec,'sym4');
y = abs(y).^2;
if plot_flag
figure
subplot(2,1,1)
plot(ecg_vec)
subplot(2,1,2)
plot(y)
hold on 
end
%%  Make new annotation indxs on the maximum
window_to_scan=10;
new_ann_vec=[];
for counter=1:numel(ann_vec)
[~,b]=max(    y(     max([ann_vec(counter)-window_to_scan 1]):min([ann_vec(counter)+window_to_scan numel(ecg_vec)])  )    );
new_ann_vec=[new_ann_vec max([b-window_to_scan+ann_vec(counter)-1 1])];
end
new_ann_vec(new_ann_vec>numel(ecg_vec))=[];
if plot_flag
plot(new_ann_vec,y(new_ann_vec),'rx')
end
%%  Find T wave peak indxs
new_ann_vec_T=[];
for counter=1:numel(new_ann_vec)
[~,b]=max(    y(     max([new_ann_vec(counter)+window_to_scan 1]):min([new_ann_vec(counter)+3*window_to_scan numel(ecg_vec)])  )    );
new_ann_vec_T=[new_ann_vec_T b+window_to_scan+new_ann_vec(counter)-1];
    
end
if plot_flag
plot(new_ann_vec_T,y(new_ann_vec_T),'ko')
end
if numel(new_ann_vec_T)>numel(new_ann_vec)
    new_ann_vec_T_repaired=[];
    for counter=1:numel(new_ann_vec)
        [~,b]=min(abs(new_ann_vec(counter)-new_ann_vec_T));       
        new_ann_vec_T_repaired(counter)=new_ann_vec_T(b);
    end
   new_ann_vec_T= new_ann_vec_T_repaired;
end
if numel(new_ann_vec)>numel(new_ann_vec_T)
    new_ann_vec_repaired=[];
    for counter=1:numel(new_ann_vec_T)
        [~,b]=min(abs(new_ann_vec_T(counter)-new_ann_vec));       
        new_ann_vec_repaired(counter)=new_ann_vec(b);
    end
    new_ann_vec=new_ann_vec_repaired;
end


abnormal_peak_thresh=0.5;
peak_vs_t_amplitude_ratio=y(new_ann_vec_T)./y(new_ann_vec);


abnormal_peaks_indxs=find(peak_vs_t_amplitude_ratio>mean(peak_vs_t_amplitude_ratio)+2*std(peak_vs_t_amplitude_ratio));
if numel(abnormal_peaks_indxs) && plot_flag
plot(new_ann_vec(abnormal_peaks_indxs),y(new_ann_vec(abnormal_peaks_indxs)),'ro')
end
abnormal_peaks_num=numel(abnormal_peaks_indxs);

