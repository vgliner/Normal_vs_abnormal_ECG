function cleaned_vec=spectrogram_cleaner(vector_to_clean,pivot_vector)
 %%  Spectrogram test for noisy segments removal
 segment_length=2000;
 for counter=1:segment_length:(numel(pivot_vector)-segment_length)
    A=spectrogram(pivot_vector(counter:(counter+segment_length)));
    A=abs(A);
  %  surf(A)
    siz=size(A);
    relative_noise=A(end,:)./max(A)*100;
    [~,segment_to_eliminate]=max(relative_noise);
    if relative_noise(segment_to_eliminate)>10
            vector_to_clean(2000/siz(2)*(segment_to_eliminate-1)+1:2000/siz(2)*(segment_to_eliminate))=mean(vector_to_clean(2000/siz(2)*(segment_to_eliminate-1)+1:2000/siz(2)*(segment_to_eliminate)));
            break
    end
%    waitforbuttonpress
 end
% plot(vec_test)
cleaned_vec=vector_to_clean;
