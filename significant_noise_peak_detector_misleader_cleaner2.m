function [cleaned_vector, spectrogram_output,suspected_noisy_indxs,Thresh]=significant_noise_peak_detector_misleader_cleaner2(vector_to_clean,samples_in_batch,threshold)
AA=abs(spectrogram(diff(vector_to_clean),samples_in_batch));
siz=size(AA);
%I3 = imadjust(AA);
I3 = imsharpen(AA(1:35,:));
%imshow(I3);
bw = imbinarize(I3);
%imshow(bw)
cc = bwconncomp(bw, 4);
graindata = regionprops(cc, 'basic');
%%   cleaner
if numel(graindata)
    indxs_to_clean=[];
    for cntr=1:numel(graindata)
        if graindata(cntr).BoundingBox(3)>6 % 6!!!!
            indxs_to_clean=[indxs_to_clean ceil(graindata(cntr).BoundingBox(1)*numel(vector_to_clean)/siz(2)):floor((graindata(cntr).BoundingBox(1)+graindata(cntr).BoundingBox(3))*numel(vector_to_clean)/siz(2))];
                
        end
    end
end
indxs_to_clean=unique(indxs_to_clean);


% %% Additional cleaner 22/05
% graindata_areas=[];
% for ctr=1:numel(graindata)
% graindata_areas=[graindata_areas; graindata(ctr).Area];
% end
% mean_graindata_areas=mean(graindata_areas);
% std_graindata_areas=std(graindata_areas);
% 
% indx_of_area_outlier=find(graindata_areas>mean_graindata_areas+3*std_graindata_areas);
% if numel(indx_of_area_outlier)
%     for cntr=1:numel(indx_of_area_outlier)
%             indxs_to_clean=[indxs_to_clean ceil(graindata(indx_of_area_outlier(cntr)).BoundingBox(1)*numel(vector_to_clean)/siz(2)):floor((graindata(indx_of_area_outlier(cntr)).BoundingBox(1)+graindata(indx_of_area_outlier(cntr)).BoundingBox(3))*numel(vector_to_clean)/siz(2))];
%     end            
% end
% indxs_to_clean=unique(indxs_to_clean);

%%  Clean High Frequencies
Thresh=threshold*mean(smooth(AA(end,:)));
Thresh_low_freq=1.3*threshold*mean(smooth(AA(1,:),3));
Thresh_mid_freq=8*mean(smooth(AA(15,:),3));

%%
cleaned_vector=vector_to_clean;
vv=smooth(AA(end,:),7);
vvv=smooth(AA(1,:),4);  %Optimization counter  vvv=smooth(AA(1,:),4); 
vvvv=smooth(AA(15,:),4);

y = resample(vv,numel(vector_to_clean),numel(vv));
z = resample(vvv,numel(vector_to_clean),numel(vvv));
w = resample(vvvv,numel(vector_to_clean),numel(vvvv));
[suspected_noisy_indxs]=find((y>0.8*Thresh)+(z>Thresh_low_freq)+(w>Thresh_mid_freq));
%cleaned_high_freq=sum((z>Thresh_low_freq));
indxs_to_clean=[indxs_to_clean suspected_noisy_indxs'];
indxs_to_clean=unique(indxs_to_clean);
indxs_to_clean(indxs_to_clean>numel(vector_to_clean))=[];
%% Clean sectors at the beginning and the end 
% if numel(indxs_to_clean)>3
%      if (max(indxs_to_clean)<numel(vector_to_clean)/5)&&(numel(vector_to_clean)>3000)
%          indxs_to_clean=1:floor(numel(vector_to_clean)/5);
%      end
%      if (min(indxs_to_clean)>4*numel(vector_to_clean)/5)&&(numel(vector_to_clean)>3000)
%          indxs_to_clean=floor(4*numel(vector_to_clean)/5):numel(vector_to_clean);
%      end     
% end
%% 
if numel(indxs_to_clean) && (numel(indxs_to_clean)/numel(vector_to_clean)<0.3)
cleaned_vector(indxs_to_clean)=[];
elseif numel(suspected_noisy_indxs)
cleaned_vector(suspected_noisy_indxs)=[];    
indxs_to_clean=suspected_noisy_indxs;
else
indxs_to_clean=[];   
end
% plot(vector_to_clean)
% hold on
% plot(cleaned_vector)
% plot((diff(cleaned_vector)))
% hold on
% plot(medfilt1(diff(cleaned_vector)))


spectrogram_output=(AA);
suspected_noisy_indxs=indxs_to_clean;