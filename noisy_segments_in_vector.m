function potentially_noisy_indxs_in_vector=noisy_segments_in_vector(cleaned_vector,Fs)
%plot(cleaned_vector)
chunk_length=4; %sec
num_of_chunks=ceil(numel(cleaned_vector)/(chunk_length*Fs));
entropy_vec=[];
for chunks_counter=1:num_of_chunks
    start_indx=max((chunks_counter-1)*Fs*chunk_length+1,1);
    end_indx=min((chunks_counter)*Fs*chunk_length+1,numel(cleaned_vector));    
    entropy(chunks_counter)=wentropy(cleaned_vector(start_indx:end_indx),'shannon');
    entropy_vec(start_indx:end_indx)=entropy(chunks_counter);
end
mean_entropy_vec=mean(entropy_vec);
std_entropy_vec=std(entropy_vec);
potentially_noisy_indxs_in_vector=find(entropy_vec>(mean_entropy_vec+1*std_entropy_vec));
% hold on
% plotyy(1:end_indx,entropy_vec,1:end_indx,cleaned_vector(1:end_indx))