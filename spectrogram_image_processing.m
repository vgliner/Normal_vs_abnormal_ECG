function [spectrogram_noise_info,lobs_mean_area,lobs_area_std,centroid_mean,centroid_std,vector_to_clean]=spectrogram_image_processing(spectrogrtam_in,t_end)
% figure(2)
[a,b]=max(spectrogrtam_in(1:60,:));
Thresh=mean(a);

d=b(a>1.5*Thresh);
% subplot(4,1,1)
%  plot(d)
% subplot(4,1,2)
e=find(a>1.5*Thresh);
% plot(diff(e))
coefficient=std(d)/numel(e);
spectrogram_noise_info=[coefficient std(diff(e))/mean(diff(e))/t_end*100];
% subplot(4,1,3)
%imagesc(spectrogrtam_in)
 I3 = imadjust(abs(spectrogrtam_in));
%imshow(I3);
bw = imbinarize(I3);
%imshow(bw)
cc = bwconncomp(bw, 4);
graindata = regionprops(cc, 'basic');
if numel(graindata)>0
    for counter=1:numel(graindata)
        lobs_area(counter)=graindata(counter).Area;
        centoid_coordinate(counter)=graindata(counter).Centroid(2);
    end
lobs_mean_area=mean(lobs_area);
lobs_area_std=std(lobs_area);
centroid_mean=mean(centoid_coordinate);
centroid_std=std(centoid_coordinate);


else
lobs_mean_area=0;  
lobs_area_std=0;    
centroid_mean=0;
centroid_std=0;
end

% subplot(3,2,5)
% AAA=abs(spectrogrtam_in);
% BW1 = edge(AAA,'sobel');
% % imshow(BW1)
% E2 = entropyfilt(AAA);
% E2im = mat2gray(E2);
% imshow(E2im);
% theta = 0:180;
% [R,xp] = fanbeam(AAA);
% imagesc(theta,xp,R);
% title('R_{\theta} (X\prime)');
% xlabel('\theta (degrees)');
% ylabel('X\prime');
% % set(gca,'XTick',0:20:180);
%  colormap(jet);
% colorbar

end
