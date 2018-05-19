function [QS_width,rmse_p,rmse_t,morphological_distance,suspected_neg_beats,max_distance_between_morphologically_good_peaks,T_R_ratio,T_P_ratio,RS_slope,QR_RS_slope_ratio,t_wave_a,QR_Morphology_change,RS_Morphology_change,u_tp_ratio,sigma_tp_ratio,bundle_block_suspect,Q_level,S_level,cross_corr,min_der_ST_segment,others_cross_corr,others_cross_corr2,S_R_ratio]=beat_morphology_analysis(average_beat_vec,val,peakInds,Fs,polarity,potentially_noisy_indxs_in_vector,plot_flag,correlation_template,others_template)
%%  Find R indx
[a,b]=max(average_beat_vec(ceil(numel(average_beat_vec)/2)-30:ceil(numel(average_beat_vec)/2)+30));
R_indx=ceil(numel(average_beat_vec)/2)-31+b;
if plot_flag
hold on
plot(R_indx,a,'rx','linewidth',3)
hold off
end
abs_diff_average_beat_vec=abs(diff(average_beat_vec));

%% Find Q indx
if R_indx-4>1
Q_indx=R_indx-3;
else
Q_indx=R_indx;    
end
while ((average_beat_vec(Q_indx-1)<average_beat_vec(Q_indx))&& (abs_diff_average_beat_vec(Q_indx-1)>mean(abs_diff_average_beat_vec))) || (abs(average_beat_vec(Q_indx))>0.7*abs(average_beat_vec(R_indx)))
    if Q_indx>3
        Q_indx=(Q_indx-1);
    else
        break;
    end
end
if plot_flag
hold on
plot(Q_indx,average_beat_vec(Q_indx),'kx','linewidth',3)
hold off
end

%% Find S indx
if (R_indx+3)<numel(average_beat_vec)
S_indx=R_indx+3;
else
S_indx=R_indx;    
end
while (average_beat_vec(S_indx+1)<average_beat_vec(S_indx))&& abs_diff_average_beat_vec(S_indx+1)>mean(abs_diff_average_beat_vec)
    if S_indx<numel(average_beat_vec)-3
        S_indx=(S_indx+1);
    else
        break;
    end
end
if plot_flag
hold on
plot(S_indx,average_beat_vec(S_indx),'mx','linewidth',3)
hold off
end
QS_width=(S_indx-Q_indx)/Fs;

%%  P wave analysis
initial_indx=max(Q_indx-60,1);
p_segment=average_beat_vec(initial_indx:Q_indx);
[p_value,p_indx]=max(p_segment);
if plot_flag
hold on
plot(initial_indx+p_indx,average_beat_vec(initial_indx+p_indx),'ko','linewidth',3)
hold off    
end
p=polyfit(initial_indx:Q_indx,average_beat_vec(initial_indx:Q_indx),1);
y = polyval(p,initial_indx:Q_indx);
if plot_flag
hold on
plot(initial_indx:Q_indx,y)
hold off
end
[~,rmse_p] = rsquare(y,p_segment);
if plot_flag
    title(['RMSE P: ' num2str( rmse_p)]);
end
%%  T wave analysis
initial_indx=min(S_indx+10,numel(average_beat_vec));
end_indx=min(numel(average_beat_vec),initial_indx+100);
t_segment=average_beat_vec(initial_indx:end_indx);
p=polyfit(initial_indx:end_indx,average_beat_vec(initial_indx:end_indx),1);
y = polyval(p,initial_indx:end_indx);
if plot_flag
hold on
plot(initial_indx:end_indx,y)
hold off
end
[~,rmse_t] = rsquare(y,t_segment);

[morphological_distance,suspected_neg_beats,max_distance_between_morphologically_good_peaks]=calc_average_morphological_distance(val,average_beat_vec,peakInds,potentially_noisy_indxs_in_vector,polarity,Fs);

%%  Calculate T wave enlargement realtive to R
[T_peak,T_peak_ind]=max(t_segment(1:end-5));
if plot_flag
hold on
plot(initial_indx+T_peak_ind,average_beat_vec(initial_indx+T_peak_ind),'ko','linewidth',3)
hold off
end
T_R_ratio=(T_peak-average_beat_vec(S_indx))/(average_beat_vec(R_indx)-average_beat_vec(S_indx));


%%  Calculate T/P ratio
T_P_ratio=(T_peak-average_beat_vec(S_indx))/(p_value-average_beat_vec(S_indx));
 if QS_width<0.028
     T_P_ratio=1.15;
     T_R_ratio=0.15;
 end
 
 if abs(T_P_ratio)>50
     T_P_ratio=1.15;     
 end
  if abs(T_R_ratio)>2
     T_R_ratio=0.15;
  end
 
  %%  Calculate RS Slope
  RS_slope=(average_beat_vec(S_indx)-a)*Fs/(S_indx-R_indx);
  QR_slope=(a-average_beat_vec(Q_indx))*Fs/(R_indx-Q_indx);
  %% Calculate  QR slope/RS slope
  QR_RS_slope_ratio=abs(QR_slope/RS_slope);
  
  %%  Parabola fit to T wave
T_peak_ind_global=  initial_indx+T_peak_ind;
prefferable_segment_length=20;
practical_segment_length=min(numel(average_beat_vec)-T_peak_ind_global,prefferable_segment_length);
select_segment_for_fitting=average_beat_vec(T_peak_ind_global-practical_segment_length:T_peak_ind_global+practical_segment_length);
try
    p=polyfit(1:numel(select_segment_for_fitting),   select_segment_for_fitting,2);
    y1 = polyval(p,1:numel(select_segment_for_fitting));
    t_wave_a=p(1);
catch
    t_wave_a=0;
    
end
% plot(average_beat_vec)
% hold on 
% plot(T_peak_ind_global,average_beat_vec(T_peak_ind_global),'x')
%% Calculate qrs morphology outliers - bundle blocks
% Normalize qrs segment
average_beat_vec_qrs=average_beat_vec;
average_beat_vec_qrs=(average_beat_vec_qrs-average_beat_vec_qrs(Q_indx))/(average_beat_vec_qrs(R_indx)-average_beat_vec_qrs(Q_indx));
QR_Morphology_change=std(diff(average_beat_vec_qrs(Q_indx:R_indx)))/mean(diff(average_beat_vec_qrs(Q_indx:R_indx)));
RS_Morphology_change=std(diff(average_beat_vec_qrs(R_indx:S_indx)))/mean(diff(average_beat_vec_qrs(R_indx:S_indx)));
[u_tp_expected, u_tp_actual, sigma_tp_expected, sigma_tp_real] = turningPointRatio (average_beat_vec_qrs(Q_indx:S_indx));
u_tp_ratio=u_tp_actual/u_tp_expected;
sigma_tp_ratio=sigma_tp_real/sigma_tp_expected;

%% Bundle Block peak
[~,bundle_block_peak]=max(average_beat_vec(S_indx:S_indx+8));

    if (bundle_block_peak>=7)||(bundle_block_peak<=2)
    bundle_block_suspect=0;
    else
    bundle_block_suspect=1;    
    end
if plot_flag
hold on
if bundle_block_suspect
        plot(S_indx+bundle_block_peak,average_beat_vec(S_indx+bundle_block_peak-1),'k+','linewidth',2)        
else
         plot(S_indx+bundle_block_peak,average_beat_vec(S_indx+bundle_block_peak-1),'m+','linewidth',2)    
end
hold off
end

%%   Q & S Levels
Q_level=average_beat_vec(Q_indx);
S_level=average_beat_vec(S_indx);

%% Calculate correlaions with common peaks
size_correlation_template=size(correlation_template);
try
        cross_corr=0;
    for correlation_counter=1:2%size_correlation_template(2)
        x=average_beat_vec(R_indx-20:R_indx+20);
        y=correlation_template;
        cross_corr_vec=    xcov(polarity*x,y(:,correlation_counter),'coeff');
        cross_corr=max(cross_corr,abs(cross_corr_vec(41)));
    end
catch
    cross_corr=1;
end

%% Other correlation template
try
    for correlation_counter=1%size_correlation_template(2)
        x=average_beat_vec(R_indx-20:R_indx+40);
        y=others_template;
        others_cross_corr_vec=    xcov(polarity*x,y(:,correlation_counter),'coeff');
        others_cross_corr=max(0,abs(others_cross_corr_vec(61)));
    end
catch
    others_cross_corr=0;
end

try
    for correlation_counter=2%size_correlation_template(2)
        x=average_beat_vec(R_indx-20:R_indx+40);
        y=others_template;
        others_cross_corr_vec=    xcov(polarity*x,y(:,correlation_counter),'coeff');
        others_cross_corr2=max(0,abs(others_cross_corr_vec(61)));
    end
catch
    others_cross_corr2=0;
end

%% 
try
min_der_ST_segment=min(abs(diff(average_beat_vec(S_indx+30:initial_indx+T_peak_ind))));
if numel(min_der_ST_segment)<1
 min_der_ST_segment=0;   
end
catch
min_der_ST_segment=0;
end
if plot_flag
    xlabel(['Xcorr= ' num2str(cross_corr) '    Min. ST der. : ' num2str(min_der_ST_segment) 'Others cross corr. ' num2str(others_cross_corr)]); 
end

%% S/R Ratio
S_R_ratio=abs(average_beat_vec(S_indx)-average_beat_vec(Q_indx))/abs(average_beat_vec(R_indx)-average_beat_vec(Q_indx));
if plot_flag
    ylabel(['S\R Ratio  ' num2str(S_R_ratio)]);
end